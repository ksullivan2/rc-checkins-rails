class ClearGroupsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    recursers = Recurser.all
    recursers.each do |rcer|
    	rcer.update({:group_id => nil})
    end
    ClearGroupsJob.delay(run_at: 7.days.from_now).perform_later
  end
end
