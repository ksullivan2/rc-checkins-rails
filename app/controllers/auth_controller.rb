class AuthController < ApplicationController
	@@client_id     = ENV["RC_TESTING_ID"]
	@@client_secret = ENV["RC_TESTING_SECRET"]
	@@redirect_uri  = 'urn:ietf:wg:oauth:2.0:oob' # your client's redirect uri
	@@site          = 'https://www.recurse.com'

	@@client = OAuth2::Client.new(@@client_id, @@client_secret, site: @@site)


	def start
  	# puts "TEST AUTH"
  	# puts "ID" + ENV["RC_TESTING_ID"]
  	# puts "SECRET" + ENV["RC_TESTING_SECRET"]
  	# rc_url = "https://recurse.com/oauth/authorize?client_id=" + ENV["RC_TESTING_ID"] + "&client_secret=" + ENV["RC_TESTING_SECRET"] + "&redirect_uri=urn:ietf:wg:oauth:2.0:oob"
  	# puts rc_url
  	# redirect_to rc_url 
  	
		
		redirect_to @@client.auth_code.authorize_url(redirect_uri: @@redirect_uri)

  	# redirect_to "/"
  end

  def callback
  	code = params[:code]
  	token = @@client.auth_code.get_token(code, redirect_uri: @@redirect_uri)
  	session["token"] = token
  	@user = JSON.parse(token.get("/api/v1/people/me").body)

  	
  	redirect_to recursers_path(recurser: {:name => @user["first_name"] + @user["last_name"], :email => @user["email"]})
  end

  
end
