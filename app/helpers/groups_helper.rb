module GroupsHelper
	def ping_success_helper(ping_success)
		if ping_success == "true"
		 return "Your check-ins have been scheduled."
		elsif Time.zone.now.thursday?
			return "You haven't actually signed up for a group... Come back tomorrow!"
		else
			return "Something went wrong..."
		end
	end

end
