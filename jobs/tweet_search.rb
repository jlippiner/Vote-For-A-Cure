require 'open-uri'
require 'json'

class TweetSearch

  def initialize
    audit_logfile = File.open("#{RAILS_ROOT}/log/tweet_search.log", 'a')
    audit_logfile.sync = true
    @ts_log = AuditLogger.new(audit_logfile)
    dwrite 'INITIALIZING TWEET SEARCH!'
  end

  def perform()
    count = 0
    begin
      login = 'voteforacure' if Search.last.user == 'endsmadotcom'
      login || 'endsmadotcom'
      user = User.find_by_login(login)

      if user
        user.twitter.get('/account/verify_credentials')
        dwrite("TweetSearch (#{user.login}): Logged in successful")

        # Get a list of all status_ids to contact
        tweets = []
        max_since_id = Search.maximum(:status_id)
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

          if message.scan(/gsf/i).blank? && message.scan(/sma/i) && message.scan(/strong/i) # in case it makes it past twitter
            search = Search.create(:status_id => status_id, :from_user => from_user, :from_user_id => from_user_id, :message => message, :user => user)
            if search.save
              begin
                user.twitter.post('/statuses/update.json', 'status' => "@#{from_user} that's great! Please use one of your remaining Chase votes to cure a disease killing children. http://VoteForSMA.com", 'in_reply_to_status_id' => tweet['id'])
                dwrite("TweetSearch: reached out to #{from_user} with message")
                count += 1
              rescue Exception => e
                dwrite("** TweetSearch ERROR: #{e.message}.)
              end
            end
          end
        end

        dwrite ("TweetSearch: Sent messages to #{count} new people.  #{Search.count} people thus far in total.")
      end

      true
    rescue Exception => e
      dwrite("** TweetSearch ERROR: #{e.message}.  #{count} messages did go out before the error.")
      false
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

# run it
def main
  ts = TweetSearch.new
  dwrite("!! TweetSearch Completed Successfully at #{Time.now}") if ts.perform
end

main
