class ZulipPingJob < ActiveJob::Base
  queue_as :default

  @@uri = URI("https://api.zulip.com/v1/messages")
 
  def perform(recurser)
    res = zulip_post('type' => 'private', 'content' => 'test', 
    	'to' => recurser['zulip_email'])
    puts res.body
  end

  private
  	def zulip_post(params)
  		req = Net::HTTP::Post.new(@@uri) 
  		req.form_data = params
  		req.basic_auth Rails.application.secrets.zulip_api_email, Rails.application.secrets.zulip_api_key
  		Net::HTTP.start(@@uri.hostname, @@uri.port, :use_ssl => true){|http| http.request(req)}
  	end
end
