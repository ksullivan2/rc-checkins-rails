class RecursersController < ApplicationController
	def new
	end

	def create
		@recurser = Recurser.new(recurser_params)

		@recurser.save
		redirect_to "/"
	end

	private
		def recurser_params
			params.require(:recurser).permit(:name, :email)
		end
end
