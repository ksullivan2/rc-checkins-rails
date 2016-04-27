class ScheduleCheckinsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    recursers = Recurser.all
    date = Time.zone.local(2016,4,27,12,26)

    recursers.each do |rcer|

    	
    	ZulipPingJob.delay(run_at: date).perform_later(rcer)
    end
  end
end
