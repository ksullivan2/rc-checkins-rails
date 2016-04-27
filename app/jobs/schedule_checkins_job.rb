class ScheduleCheckinsJob < ActiveJob::Base
  queue_as :default

  def perform(recurser)
  	remove_existing_jobs(recurser.email)

  	# find the correct time of day to ping
  	# Time.parse will default to TODAY
    group = Group.find(recurser.group_id)
    pingtime = Time.parse(group.time)


    weekday = Time.zone.now.wday
    	
    # a check so you don't get pinged if the time today has already passed
    weekday += 1 if Time.zone.now >= pingtime
    
    # checks if we're scheduling jobs for this week or next week
    # wday (4) == Thursday
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
	  
	  
    # schedule the correct number of jobs on correct days
    (start..4).each do |w|
    	# adds days to the pingtime(value for + is in seconds)
    	dailypingtime = pingtime + (86400 * (w-start))

    	# schedule a ping
    	content = "Your check-in starts now in #{group.room}"
    	ZulipPingJob.delay(queue: recurser.email, run_at: dailypingtime).perform_later(recurser.zulip_email, content)
    end
  end

  private
  	def remove_existing_jobs(queue)
  		jobs = Delayed::Job.where(queue: queue)
  		jobs.each do |job|
  			Delayed::Job.find(job.id).destroy
  		end
  	end

end
