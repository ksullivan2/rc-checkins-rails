def date_of_next(day)
  date  = Date.parse(day)
  delta = date > Date.today ? 0 : 7
  date + delta
end

job_time = date_of_next("Thursday") + 13.5.hours
jobs = Delayed::Job.where(queue: "clear_groups")

if jobs.length == 0
  ClearGroupsJob.delay(queue: "clear_groups", run_at: job_time).perform_later
end
