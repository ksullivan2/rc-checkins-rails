class ClearGroupsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    recursers = Recurser.all
    recursers.each do |rcer|
      rcer.update({:group_id => nil})
    end
    one_week_from_now = Time.now + 86400*7
    ClearGroupsJob.delay(run_at: one_week_from_now).perform_later
  end
end
