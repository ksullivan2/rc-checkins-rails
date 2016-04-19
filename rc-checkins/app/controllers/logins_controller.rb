class LoginsController < ApplicationController
	def create
		session[:current_user_id] = user.current_user_id
		redirect_to "/"
	end
end
