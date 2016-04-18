class RecursersController < ApplicationController
	def new
		@recurser = Recurser.new
	end

	def create
		@group = Group.find(params[:group_id])
		@recurser = @group.recursers.create(recurser_params)
		redirect_to "/"
	end

	def destroy
    @group = Group.find(params[:group_id])
    @recurser = @group.recursers.find(params[:id])
    @recurser.destroy
    redirect_to "/"
  end

	private
		def recurser_params
			params.require(:recurser).permit(:name, :email)
		end
end
