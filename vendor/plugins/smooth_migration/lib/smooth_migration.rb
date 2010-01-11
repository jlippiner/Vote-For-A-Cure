module SmoothMigration #:nodoc:
  mattr_accessor :disabled
  mattr_accessor :exception_count
  
  def self.included(base)
    self.exception_count = 0
    base.class_eval do
      alias_method_chain :method_missing, :smoothness
    end
  end
  
  def method_missing_with_smoothness(method, *args, &block)
    method_missing_without_smoothness(method, *args, &block)
  rescue => ex
    raise if self.disabled
    say ex.class.to_s, true
    say ex.message, true
    self.exception_count += 1
  end

end
