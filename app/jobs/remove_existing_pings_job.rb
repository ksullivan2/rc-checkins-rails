class RemoveExistingPingsJob < ActiveJob::Base
  queue_as :default

  def perform(recurser)
    jobs = Delayed::Job.where(queue: recurser.email)
  		jobs.each do |job|
  			Delayed::Job.find(job.id).destroy
  		end
  end
end
