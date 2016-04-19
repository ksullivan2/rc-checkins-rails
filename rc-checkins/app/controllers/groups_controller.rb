class GroupsController < ApplicationController
	def index
		if !session[:current_user_id].nil?
			@groups = Group.all
		else
			redirect_to '/login'
		end

		# @groups = Group.all
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

	def update
		@group = Group.find(params[:id])
		@group.update(group_params)

		redirect_to "/"
		#error handling here!

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
