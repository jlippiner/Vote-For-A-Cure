module SmoothMigrator #:nodoc:
  
  def self.included(base)
    base.class_eval do
      alias_method_chain :migrate, :smoothness
    end
  end
  
  def migrate_with_smoothness(*args)
    SmoothMigration.exception_count = 0
    SmoothMigration.disabled = true if ENV['SMOOTH'] == "false"
    migrate_without_smoothness(*args)
    unless SmoothMigration.disabled || SmoothMigration.exception_count.zero?
      raise ActiveRecord::FailedMigration, "-- #{SmoothMigration.exception_count} Failures!  Review console output."
    end
  end
end
