class GroupsController < ApplicationController
	def index
		@groups = Group.all
	end

	def new
		@group = Group.new
	end

	def create
		@group = Group.new(group_params)

		if @group.save
			redirect_to "/"
		else
			render 'new'
		end
	end

	def destroy
		@group = Group.find(params[:id])
		@group.destroy
		redirect_to "/"
	end


	private
		def group_params
			params.require(:group).permit(:room, :time, :topic)
		end
end
