require 'open-uri'
require 'json'

class TweetSearch

  def initialize()
    audit_logfile = File.open("#{RAILS_ROOT}/log/tweet_search.log", 'a')
    audit_logfile.sync = true
    @ts_log = AuditLogger.new(audit_logfile)
    dwrite 'INITIALIZING TWEET SEARCH!'
  end

  def perform
    # get the latest chase giving mentions and store in database without a user
    # Get a list of all status_ids to contact
    max_since_id = Search.maximum(:status_id)
    1.upto(15) do |page_number|
      dwrite("TweetSearch: Retrieving tweets from page #{page_number}")
      tweets = twitter_search('ChaseGiving%2B-SMA%2B-Strong%2B-GSF',page_number, max_since_id)

      tweets["results"].each do |tweet|
        status_id = tweet['id']
        from_user = tweet['from_user']
        from_user_id = tweet['from_user_id']
        message = tweet['text']

        if message.scan(/gsf/i).blank? && message.scan(/sma/i).blank? && message.scan(/strong/i).blank? # in case it makes it past twitter
          search = Search.create(:status_id => status_id, :from_user => from_user, :from_user_id => from_user_id, :message => message, :user => nil)
        end
      end if tweets["results"]

      dwrite("TweetSearch: #{tweets["results"].count} new tweets found")
    end
  end

  def catch_up
    Tweet.without_searches.each do |tweet|
      user = tweet.user if tweet

      if user && tweet
        begin
          user.twitter.get('/account/verify_credentials')
          dwrite("Tweet Replies: Login successful for #{user.login}")

          dwrite("Tweet Replies: #{Search.available.count} searches available")
          searches = Search.available.find(:all, :limit => 10)
          searches.each {|x| x.update_attribute(:in_process, true) }

          searches.each do |search|
            begin
              user.twitter.post('/statuses/update.json', 'status' => "@#{search.from_user} that's great! Please use one of your remaining Chase votes to cure a disease killing children - http://VoteForSMA.com", 'in_reply_to_status_id' => search.status_id)
              dwrite("Tweet Replies from #{user.login}: reached out to #{search.from_user} with message")
              search.update_attribute(:user, user)
            rescue Exception => e
              dwrite("** Tweet Replies ERROR for #{user.login}: #{e.message}.")
            end
          end

        rescue Exception => e
          dwrite("** Tweet Replies Login ERROR for #{user.login}: #{e.message}.")
        end
      end
    end
  end

  def twitter_search(query,page_number=1,since_id=1,number_to_fetch=100)
    begin
      JSON.parse(open("http://search.twitter.com/search.json?q=#{query}&since_id=#{since_id}&rpp=#{number_to_fetch}&page=#{page_number}").read)
    rescue Exception => e
      nil
    end
  end

  def dwrite(msg)
    puts msg
    @ts_log.info msg
  end
end

def main
  ts = TweetSearch.new
  ts.perform
end

main
