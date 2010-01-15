require 'open-uri'
require 'json'

class TweetSearch

  def perform
    user = User.find_by_login('endsmadotcom')

    if user
      user.twitter.get('/account/verify_credentials')
      dwrite("TweetSearch (#{user.login}): Logged in successful")

      # Get a list of all status_ids to contact
      max_since_id = Search.maximum(:status_id)
      tweets = []
      1.upto(15) do |page_number|
        dwrite("TweetSearch: Retrieving tweets from page #{page_number}")
        page_of_tweets = twitter_search('ChaseGiving+-SMA+-Strong+-GSF',page_number, max_since_id)
        tweets = tweets + page_of_tweets["results"] if page_of_tweets["results"]
      end

      tweets.each do |tweet|
        status_id = tweet['id']
        from_user = tweet['from_user']
        from_user_id = tweet['from_user_id']
        message = tweet['text']

        search = Search.create(:status_id => status_id, :from_user => from_user, :from_user_id => from_user_id, :message => message)
        if search.save
          user.twitter.post('/statuses/update.json', 'status' => "@#{from_user} that's great! Please use one of your remaining Chase votes to cure a disease killing children. http://VoteForSMA.com", 'in_reply_to_status_id' => tweet['id'])
          dwrite("TweetSearch: reached out to #{from_user} with message")
        end
      end
    end

    true
  end

  def twitter_search(query,page_number=1,since_id=1,number_to_fetch=100)
    begin
      JSON.parse(open("http://search.twitter.com/search.json?q=#{CGI.escape(query)}&since_id=#{since_id}&rpp=#{number_to_fetch}&page=#{page_number}").read)
    rescue Exception => e
      nil
    end
  end


  def dwrite(msg)
    puts msg
    Rails.logger.info("==> #{msg}")
  end
end
