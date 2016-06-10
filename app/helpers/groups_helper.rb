module GroupsHelper
  def ping_success_helper(ping_success)
    if ping_success == "true"
      return "Your check-ins have been scheduled."
    else
      return "Something went wrong..."
    end
  end

end
