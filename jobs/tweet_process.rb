def main
  STDIN.each do |arg|
    dwrite("Twitter Process: Oauth - STARTING PROCESS OF TWEET at #{Time.now} for Tweet ID : #{arg}")

    tweet = Tweet.find_by_id(arg) if arg
    user = tweet.user if tweet

    if user && tweet

      user.twitter.get('/account/verify_credentials')
      dwrite("Twitter (#{login}): Logged in successful")

      # Update their status
      user.twitter.post('/statuses/update.json', 'status' => tweet.status.message)
      dwrite("Twitter (#{login}): updated status for user ")

      # DM their friends if selected
      if tweet.send_dm && user.followers_count > 0
        dm_post = "Just wanted to let you know I did this to help with this cause - http://EndSMA.org/twitter."
        prev_followers = Follower.all.map {|x| x.screen_name}

        1.upto(user.followers_count / 100 + 1) do |page_num|
          followers = user.twitter.get("/statuses/followers.json?screen_name=#{login}&page=#{page_num}")
          their_followers = followers.map {|x| x['screen_name']}
          new_followers = their_followers - prev_followers

          new_followers.each do |follower|
            Follower.create({:screen_name => follower, :friend_id => user.twitter_id})
            user.twitter.post('/direct_messages/new.json', 'screen_name' => follower, 'text' => dm_post)
          end
          dwrite("Twitter (#{login}): Successfully sent DMs to #{followers.size} followers out of #{user.followers_count} (Page: #{page_num})")
        end
      end

      # Add them as a follower and catch error in case they are already following
      begin
        user.twitter.post("/friendships/create.json?screen_name=gsfoundation")
        dwrite("Twitter (#{login}): Added gsfoundation as friend") if tweet.follow_us
      rescue Exception => e
        dwrite("Twitter Friend Add Error: #{e.to_s}")
      end

      #Log completed
      tweet.update_attributes({:completed => true}) 
      dwrite("Twitter (#{login}): Recorded completed as true")

      true
    end
  end

rescue Exception => e
  dwrite("Twitter Error: #{e.to_s}")
  HoptoadNotifier.notify(:error_message => e)
end

def dwrite(msg)
  puts msg
  Rails.logger.info("==> #{msg}")
end


#run it
main
