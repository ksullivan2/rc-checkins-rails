class ConfirmationJob < ActiveJob::Base
  queue_as :default

  def perform(recurser)
  	group = Group.find(recurser.group_id)
  	content = "You are confirmed for #{group.room} at #{group.time}."
    ZulipPingJob.perform_now(recurser.zulip_email, content)
  end
end
