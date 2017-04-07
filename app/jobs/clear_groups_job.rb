class ClearGroupsJob < ActiveJob::Base

  queue_as :clear_groups

  @@zulip_uri = URI("https://recurse.zulipchat.com/api/v1/messages")

  @@zulip_msg_content = <<-MSG.strip_heredoc
    Checkin groups have been reset for the week. Reminder to sign up at checkins.recurse.com if you want to participate next week!
  MSG

  def perform(*args)
    ClearGroupsJob.delay(run_at: 1.week.from_now).perform_later

    groups = Group.all
    groups.each do |group|
      group.update(:topic => "")
    end
    rcers = Recurser.all
    rcers.each do |rcer|
      unless rcer.group_id.nil?
        rcer.update(:group_id => nil)
        zulip_post(
          'type' => 'private',
          'content' => @@zulip_msg_content,
          'to' => rcer.zulip_email
        )
      end
    end
  end

  private

  def zulip_post(params)
    req = Net::HTTP::Post.new(@@zulip_uri)
    req.form_data = params
    req.basic_auth Rails.application.secrets.zulip_api_email, Rails.application.secrets.zulip_api_key
    Net::HTTP.start(@@zulip_uri.hostname, @@zulip_uri.port, :use_ssl => true){|http| http.request(req)}
  end
end
