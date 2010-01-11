def dwrite(msg)
  puts msg  if ENV["RAILS_ENV"] == 'development'
  Rails.logger.debug msg
end

def is_date?(date)
  begin
    Date.parse(date)
    true
  rescue
    false
  end
end

def pluralize_as_words(count, singular, plural = nil)
  "#{(count || 0).to_words} " + ((count == 1 || count == '1') ? singular : (plural || singular.pluralize))
end

def get_errors(object)
  @errors = ["<b>The following errors were found:</b><p><ul>"]
  object.errors.each_full {|msg| @errors << "<li>#{msg}</li>" }
  @errors << "</ul></p>"
  @errors.join()
end


class Date
  def day_name
    days = %w{Sunday Monday Tuesday Wednesday Thursday Friday Saturday}
    days[self.wday]
  end  
end

class String
  def to_title
    self.gsub(/([a-z](?=[A-Z])|[A-Z](?=[A-Z][a-z]))/, '\1 ').titleize
  end
  
  def numeric?
    true if Float(self.to_s.gsub(',','')) rescue false
  end
end