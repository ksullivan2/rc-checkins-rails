class RecursersController < ApplicationController
	@@client_id = Rails.application.secrets.RC_API_ID
	@@client_secret = Rails.application.secrets.RC_API_SECRET
	@@redirect_uri  = Rails.application.secrets.RC_API_URI
	@@site          = 'https://www.recurse.com'
	@@client = OAuth2::Client.new(@@client_id, @@client_secret, site: @@site)

	def start_auth
		redirect_to @@client.auth_code.authorize_url(redirect_uri: @@redirect_uri)
  end

  def auth_callback
  	code = params[:code]
  	token = @@client.auth_code.get_token(code, redirect_uri: @@redirect_uri)
  	session["token"] = token
  	@user = JSON.parse(token.get("/api/v1/people/me").body)

  	
  	@authed_user = {:name => @user["first_name"] + " " +  @user["last_name"], :email => @user["email"], :zulip_email => @user["email"]}
  	create(@authed_user)
  end


	def new
		@recurser = Recurser.new
	end

	def create(user)
		@recurser = Recurser.find_by email: user[:email]
		
		if @recurser
			session[:current_user] = @recurser
			redirect_to "/"

		else
			@recurser = Recurser.new(user)
			if @recurser.save
				session[:current_user] = @recurser
				redirect_to "/"
			else
				render 'new'
			end

		end
	end

	def edit
		@recurser = Recurser.find(params[:id])
	end

	def update
		@recurser = Recurser.find(params[:id])
		#group_id is a different edit case, it's not passed in as part of recurser_params
		if params[:group_id]
			@recurser.update({:group_id => params[:group_id]})
			redirect_to "/"
		elsif @recurser.update(recurser_params)
			session[:current_user] = @recurser
			redirect_to "/"
		else
			render "edit"
		end
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
end
