class RecursersController < ApplicationController
	def new
		@recurser = Recurser.new
	end

	def create
		@recurser = Recurser.new(recurser_params)

		if @recurser.save
			redirect_to "/"
		else
			render 'new'
		end
	end

	private
		def recurser_params
			params.require(:recurser).permit(:name, :email)
		end
end
