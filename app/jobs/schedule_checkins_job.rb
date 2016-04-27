class ScheduleCheckinsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    recursers = Recurser.all
    isThursday = Time.zone.now.thursday?
    weekday = Time.zone.now.wday.to_s

    recursers.each do |rcer|
    	group = Group.find(rcer.group_id)
    	pingtime = Time.parse(group.time)

    	
    	ZulipPingJob.delay(run_at: pingtime).perform_later(rcer)
    end
  end
end
