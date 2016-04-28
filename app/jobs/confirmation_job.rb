class ConfirmationJob < ActiveJob::Base
  queue_as :default

  def perform(recurser)
  	if recurser.group_id
	  	group = Group.find(recurser.group_id)
	  	content = "You are confirmed for #{group.room} at #{group.time}."
	  else
	  	content = "You have left your check-in group. =("
	  end

    ZulipPingJob.perform_now(recurser.zulip_email, content)
  end
end
