class ClearGroupsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    recursers = Recurser.all
    recursers.each do |rcer|
    	rcer.update({:group_id => nil})
    end
    ClearGroupsJob.delay(run_at: Time.now.midnight + (86400*7)).perform_later
  end
end
