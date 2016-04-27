class ScheduleCheckinsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    recursers = Recurser.all

    recursers.each do |rcer|
    	ZulipPingJob.delay(run_at: 5.seconds.from_now).perform_now(rcer)
    end
  end
end
