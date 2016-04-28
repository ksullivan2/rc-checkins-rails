weekday = Time.zone.now.wday

if weekday <= 4
  days_til_Friday = 5-weekday 	
else
	days_til_Friday = 6-weekday+6
end

job_time =  Time.now.midnight + (86400*days_til_Friday)


jobs = Delayed::Job.where(queue: "clear_groups")

if jobs.length = 0:
	ClearGroupsJob.delay(queue: "clear_groups", run_at: job_time).perform_later
end
