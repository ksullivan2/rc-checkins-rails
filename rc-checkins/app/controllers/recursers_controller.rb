class RecursersController < ApplicationController
	def new
		@recurser = Recurser.new
	end

	def create
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



	private
		def recurser_params
			params.require(:recurser).permit(:name, :email, :group_id)
		end
end
