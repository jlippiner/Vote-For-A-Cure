require 'open-uri'
require 'json'

class TweetPepsi

  def initialize()
    audit_logfile = File.open("#{RAILS_ROOT}/log/tweet_search.log", 'a')
    audit_logfile.sync = true
    @ts_log = AuditLogger.new(audit_logfile)
    dwrite 'INITIALIZING TweetPepsi!'
  end

  def perform
    send_replies if refresh_searches
  end

  def send_replies
    reply_text = "I just did! You should vote for free to help this mom win $5,000 to save her baby, cure a disease. http://bit.ly/bV99Ei"

    user = User.find_by_login('EndSMAdotcom')
    if user && !Search.by_tag('pepsi').available.count > 0
      user.twitter.get('/account/verify_credentials')
      dwrite("TweetPepsi: #{Search.available.count} searches available")
      searches = Search.by_tag('pepsi').available.find(:all, :limit => 10)
      searches.each {|x| x.update_attribute(:in_process, true) }

      searches.each do |search|
        begin
          user.twitter.post('/statuses/update.json', 'status' => reply_text, 'in_reply_to_status_id' => search.status_id)
          dwrite("TweetPepsi: reached out to #{search.from_user} with message")
          search.update_attribute(:user, user)
        rescue Exception => e
          dwrite("** TweetPepsi: #{e.message}.")
        end
      end
    end
  end

  def refresh_searches
    # get the latest chase giving mentions and store in database without a user
    # Get a list of all status_ids to contact
    max_posted_at = Search.by_tag('pepsi').maximum(:posted_at)
    max_posted_at ||= Date.new(y=2010, m=01, d=15)
    1.upto(15) do |page_number|
      dwrite("TweetPepsi: Retrieving tweets from page #{page_number}")
      tweets = twitter_search(page_number, max_posted_at.strftime('%Y-%m-%d'))

      return false unless tweets

      tweets["results"].each do |tweet|
        status_id = tweet['id']
        from_user = tweet['from_user']
        from_user_id = tweet['from_user_id']
        message = tweet['text']
        posted_at = tweet['created_at']

        search = Search.create(:status_id => status_id, :from_user => from_user, :from_user_id => from_user_id, :message => message, :tag => 'pepsi', :posted_at => posted_at)
      end if tweets["results"]

      dwrite("TweetPepsi: #{tweets["results"].count} new tweets found")
    end

    true
  end

  def twitter_search(page_number=1,since_id=1,number_to_fetch=100)
    begin
      JSON.parse(open("http://search.twitter.com/search.json?q=&ands=&phrase=vote+to+give+this+idea&ors=&nots=&tag=pepsirefresh&since=#{since_id}&rpp=#{number_to_fetch}&page=#{page_number}").read)
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
  ts = TweetPepsi.new
  ts.perform
end

main
