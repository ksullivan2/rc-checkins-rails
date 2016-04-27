class ZulipPingJob < ActiveJob::Base
  queue_as :default

  @@uri = URI("https://api.zulip.com/v1/messages")
 
  # def perform(recurser)
  # 	if recurser.group_id
  # 		group = Group.find(recurser.group_id)
  # 		# content = "You are in #{group.room} at #{group.time}."
  # 		content = Time.zone.now

	 #    res = zulip_post('type' => 'private', 'content' => content, 
	 #    	'to' => recurser['zulip_email'])
	 #    puts res.body
	 #  end
  # end

  def perform(email, content)
  	zulip_post('type' => 'private', 'content' => content, 'to' => email)
	end

  private
  	def zulip_post(params)
  		req = Net::HTTP::Post.new(@@uri) 
  		req.form_data = params
  		req.basic_auth Rails.application.secrets.zulip_api_email, Rails.application.secrets.zulip_api_key
  		Net::HTTP.start(@@uri.hostname, @@uri.port, :use_ssl => true){|http| http.request(req)}
  	end
end
