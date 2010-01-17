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
      tweets = twitter_search('ChaseGiving%2B-SMA%2B-Strong%2B-GSF',page_number, 1)

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
      return true if tweets["next_page"]
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