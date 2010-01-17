class TweetJob < Struct.new(:tweet_id)

  def initialize(tweet_id)
    audit_logfile = File.open("#{RAILS_ROOT}/log/tweet_search.log", 'a')
    audit_logfile.sync = true
    @ts_log = AuditLogger.new(audit_logfile)
    dwrite 'INITIALIZING TWEET SEARCH!'
  end

  def perform
    if tweet_id
      dwrite("Twitter Process: Oauth - STARTING PROCESS OF TWEET at #{Time.now} for Tweet ID : #{tweet_id}")
    else
      dwrite("Twitter Job: Tweet ID MISSING!!!")
    end

    tweet = Tweet.find_by_id(tweet_id) if tweet_id
    user = tweet.user if tweet

    if user && tweet
      user.twitter.get('/account/verify_credentials')
      dwrite("Twitter (#{user.login}): Logged in successful")

      # Update their status
      user.twitter.post('/statuses/update.json', 'status' => tweet.status.message)
      dwrite("Twitter (#{user.login}): updated status for user ")

      # DM their friends if selected
      if tweet.send_dm && user.followers_count > 0
        prev_followers = Follower.all.map {|x| x.screen_name}

        1.upto(user.followers_count / 100 + 1) do |page_num|
          followers = user.twitter.get("/statuses/followers.json?screen_name=#{user.login}&page=#{page_num}")
          their_followers = followers.map {|x| x['screen_name']}
          new_followers = their_followers - prev_followers

          new_followers.each do |follower|
            Follower.create({:screen_name => follower, :friend_id => user.twitter_id})
            user.twitter.post('/direct_messages/new.json', 'screen_name' => follower, 'text' => tweet.direct_message.message)
          end

          dwrite("Twitter (#{user.login}): Successfully sent DMs to #{followers.size} followers out of #{user.followers_count} (Page: #{page_num})")
        end
      end

      # Add them as a follower and catch error in case they are already following
      begin
        user.twitter.post("/friendships/create.json?screen_name=gsfoundation")
        dwrite("Twitter (#{user.login}): Added gsfoundation as friend") if tweet.follow_us
      rescue Exception => e
        dwrite("Twitter Friend Add Error: #{e.to_s}")
      end

      # Send replies on their behalf if selected
      if tweet.allow_replies && Search.available.count > 0
        searches = Search.available.find(:all, :limit => 5)
        searches.each {|x| x.update_attribute(:in_process, true)}

        searches.each do |search|
          begin
            user.twitter.post('/statuses/update.json', 'status' => "@#{search.from_user} that's great! Please also use one of your remaining Chase votes to cure a disease killing children - http://VoteForSMA.com", 'in_reply_to_status_id' => search.status_id)
            dwrite("TweetSearch: reached out to #{search.from_user} with message")
            search.update_attribute(:user, user)
          rescue Exception => e
            dwrite("** TweetSearch ERROR: #{e.message}.")
          end
        end
      end

      #Log completed
      tweet.update_attributes({:completed => true})
      dwrite("Twitter (#{user.login}): Recorded completed as true")
    end
  end

  def dwrite(msg)
    puts msg
    @ts_log.info msg
  end
end
