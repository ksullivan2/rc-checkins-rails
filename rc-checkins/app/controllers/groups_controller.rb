class GroupsController < ApplicationController
	def index
		if !session[:current_user_id].nil?
			@groups = Group.all
			#call current_user method from Application controller
			#creates variable called @_current_user
	    current_user()
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

	def update_recursers
		@new_group_id = params[:group_id]
		@current_group_id = params[:recurser][:current_group]

		#if @current_group.nil?
			redirect_to controller: 'recursers', action: 'create_from_group', group_id: @new_group_id, recurser: params[:recurser]
		#end

	end


	private
		def group_params
			params.require(:group).permit(:room, :time, :topic)
		end
end
