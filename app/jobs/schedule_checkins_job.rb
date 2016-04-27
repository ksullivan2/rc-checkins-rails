class ScheduleCheckinsJob < ActiveJob::Base
  queue_as :default

  def perform(recurser)
  	# find the correct time of day to ping
  	# Time.parse will default to TODAY
    group = Group.find(recurser.group_id)
    pingtime = Time.parse(group.time)


    #checks if we're scheduling jobs for this week or next week
    # wday (4) == Thursday
    weekday = Time.zone.now.wday
    if weekday <= 4
    	thisweek = true
    	start = weekday
    else
    	thisweek = false
    	start = 1
    end

    if !thisweek
	  	#since Time.parse defaults to today, add some days to start next Monday
	  	pingtime = pingtime + (86400 * (6-weekday+2))
	  end
	  
	  
    #schedule the correct number of jobs on correct days
    (start..4).each do |w|
    	# adds days to the pingtime(value for + is in seconds)
    	dailypingtime = pingtime + (86400 * (w-start))

    	#schedule a ping
    	ZulipPingJob.delay(queue: recurser.name, run_at: dailypingtime).perform_later(dailypingtime.to_s)
    end

  end
end
