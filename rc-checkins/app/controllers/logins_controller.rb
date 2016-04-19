class LoginsController < ApplicationController


	def create
    session[:current_user] = {:name => params[:logins][:name]}
    redirect_to "/" 
  end

  def new
  	
  end

  
end
