class RecursersController < ApplicationController
	CLIENT_ID = Rails.application.secrets.RC_API_ID
	CLIENT_SECRET = Rails.application.secrets.RC_API_SECRET
	REDIRECT_URI  = Rails.application.secrets.RC_API_URI
	SITE          = 'https://www.recurse.com'

	def start_auth
		@client = OAuth2::Client.new(CLIENT_ID, CLIENT_SECRET, site: SITE)
		redirect_to @client.auth_code.authorize_url(redirect_uri: REDIRECT_URI)
  end

  def auth_callback
  	@client = OAuth2::Client.new(CLIENT_ID, CLIENT_SECRET, site: SITE)
  	code = params[:code]
  	token = @client.auth_code.get_token(code, redirect_uri: REDIRECT_URI)
  	session["token"] = token
  	@user = JSON.parse(token.get("/api/v1/people/me").body)

  	authed_user = {:name => @user["first_name"] + " " +  @user["last_name"], :email => @user["email"], :zulip_email => @user["email"]}
  	create(authed_user)
  end


	def new
		@recurser = Recurser.new
	end

	def create(user)
		@recurser = Recurser.find_by email: user[:email]
		
		if @recurser
			update_session_user(@recurser)
			redirect_to "/"

		else
			@recurser = Recurser.new(user)
			if @recurser.save
				update_session_user(@recurser)
				redirect_to "/"
			else
				render 'new'
			end

		end
	end

	def edit
		@recurser = Recurser.find(session[:current_user]["id"])
		if session[:current_user]["id"].to_s == params[:id]
			@valid_id = true
		else
			@valid_id = false
		end
	end

	def update
		@recurser = Recurser.find(params[:id])
		#group_id is a different edit case, it's not passed in as part of recurser_params
		if params[:group_id]
			@recurser.update({:group_id => params[:group_id]})
			ScheduleCheckinsJob.perform_later(@recurser)
			update_session_user(@recurser)
			redirect_to "/"
		elsif @recurser.update(recurser_params)
			update_session_user(@recurser)
			redirect_to "/"
		else
			render "edit"
		end
	end

	def leave_group
		@recurser = Recurser.find(params[:id])
		@recurser.update({:group_id => nil})
		RemoveExistingPingsJob.perform_later(@recurser)
		update_session_user(@recurser)
		redirect_to "/"
	end


	def destroy
		@recurser = Recurser.find(params[:id])
    @recurser.destroy
    redirect_to "/"
  end


	private
		def recurser_params
			params.require(:recurser).permit(:name, :email, :group_id, :zulip_email)
		end

		def update_session_user(recurser)
			session[:current_user]= recurser
		end
end
