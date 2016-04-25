class RecursersController < ApplicationController
	def new
		@recurser = Recurser.new
	end

	def create
		@recurser = Recurser.find_by email: recurser_params[:email]
		if @recurser
			session[:current_user] = @recurser
			redirect_to "/"

		else
			@recurser = Recurser.new(recurser_params)
		
			if @recurser.save
				#add the new id to the hash
				@tempRC = params[:recurser]
				@tempRC[:id] = @recurser.id

				#save in session cookie
				session[:current_user] = @tempRC
				redirect_to "/"
			else
				render 'new'
			end
		end
	end


	def update
		@recurser = Recurser.find(params[:id])
		@recurser.update({:group_id => params[:group_id]})
		redirect_to "/"
	end



	def destroy
		@recurser = Recurser.find(params[:id])
    @recurser.destroy
    redirect_to "/"
  end

  def auth
  	# puts "TEST AUTH"
  	# puts "ID" + ENV["RC_TESTING_ID"]
  	# puts "SECRET" + ENV["RC_TESTING_SECRET"]
  	# rc_url = "https://recurse.com/oauth/authorize?client_id=" + ENV["RC_TESTING_ID"] + "&client_secret=" + ENV["RC_TESTING_SECRET"] + "&redirect_uri=urn:ietf:wg:oauth:2.0:oob"
  	# puts rc_url
  	# redirect_to rc_url 
  	client_id     = ENV["RC_TESTING_ID"]
		client_secret = ENV["RC_TESTING_SECRET"]
		redirect_uri  = 'urn:ietf:wg:oauth:2.0:oob' # your client's redirect uri
		site          = 'https://www.recurse.com'

		client = OAuth2::Client.new(client_id, client_secret, site: site)
		redirect_to client.auth_code.authorize_url(redirect_uri: redirect_uri)

  	# redirect_to "/"
  		
  end



	private
		def recurser_params
			params.require(:recurser).permit(:name, :email, :group_id)
		end
end
