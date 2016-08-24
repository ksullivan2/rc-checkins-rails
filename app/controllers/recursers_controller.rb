class RecursersController < ApplicationController
  CLIENT_ID = Rails.application.secrets.RC_API_ID
  CLIENT_SECRET = Rails.application.secrets.RC_API_SECRET
  REDIRECT_URI  = Rails.application.secrets.RC_API_URI
  SITE          = 'https://www.recurse.com'

  def start_auth
    client = create_client
    redirect_to client.auth_code.authorize_url(redirect_uri: REDIRECT_URI)
  end

  def auth_callback
    client = create_client
    code = params[:code]
    token = client.auth_code.get_token(code, redirect_uri: REDIRECT_URI)
    session["token"] = token
    user = JSON.parse(token.get("/api/v1/people/me").body)
    authed_user = {:name => user["first_name"] + " " +  user["last_name"], :email => user["email"], :zulip_email => user["email"]}
    create(authed_user)
  end


  def new
    @recurser = Recurser.new
  end

  def create(user)
    @recurser = Recurser.find_by email: user[:email]

    if @recurser
      update_session_user(@recurser.id)
      redirect_to "/"
    else
      @recurser = Recurser.new(user)
      if @recurser.save
        update_session_user(@recurser.id)
        redirect_to "/"
      else
        render 'new'
      end
    end
  end

  def edit
    current_user #sets @_current_user variable
  end

  def update
    current_user #sets @_current_user variable

    #group_id is a different edit case, it's not passed in as part of recurser_params
    if params[:group_id]
      @_current_user.update({:group_id => params[:group_id]})

      ping_success = schedule_pings


      redirect_to controller: :groups, action: :index , ping_success: ping_success.to_s
    elsif @_current_user.update(recurser_params)
      redirect_to "/"
    else
      render "edit"
    end
  end

  def leave_group
    current_user #sets @_current_user variable
    @_current_user.update({:group_id => nil})
    remove_existing_pings
    redirect_to "/"
  end


  def destroy
    @recurser = Recurser.find(params[:id])
    @recurser.destroy
    redirect_to "/"
  end


  private
  def recurser_params
    params.require(:recurser).permit(:name, :email, :group_id, :zulip_email)
  end

  def update_session_user(id)
    session[:user_id]= id
  end

  def create_client
    OAuth2::Client.new(CLIENT_ID, CLIENT_SECRET, site: SITE)
  end

  def remove_existing_pings
    jobs = Delayed::Job.where(queue: @_current_user.email)
    jobs.each do |job|
      Delayed::Job.find(job.id).destroy
    end
  end

  def schedule_pings
    remove_existing_pings

    # find the correct time of day to ping
    # Time.parse will default to TODAY
    group = Group.find(@_current_user.group_id)
    pingtime = Time.parse(group.time)


    # checks if we're scheduling jobs for this week or next week
    # wday (3) == Weds
    weekday = Time.zone.now.wday
    if weekday <= 3
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

    scheduled_something = false

    # schedule the correct number of jobs on correct days
    (start..4).each do |w|
      # adds days to the pingtime(value for + is in seconds)
      dailypingtime = pingtime + (86400 * (w-start))

      # schedule a ping
      content = "Your check-in starts now in #{group.room}."
      if dailypingtime > Time.zone.now
        scheduled_something = true
        ZulipPingJob.delay(
          queue: @_current_user.email,
          run_at: dailypingtime
        ).perform_later(
          @_current_user.zulip_email,
          content
        )
      end
    end

    jobs = Delayed::Job.where(queue: @_current_user.email)
    jobs.each do |job|
      puts job
    end

    scheduled_something #return whether something was scheduled
  end
end
