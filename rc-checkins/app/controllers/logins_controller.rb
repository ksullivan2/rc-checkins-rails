class LoginsController < ApplicationController


	def create
		@user_id = params[:logins][:name]
    session[:current_user_id] = @user_id
    redirect_to "/" 
  end

  def new
  	
  end

  
end
