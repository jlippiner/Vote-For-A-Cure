module ::ActiveRecord
  class FailedMigration < ActiveRecordError #:nodoc:
  end
  class << Migration
    include SmoothMigration
  end
  class << Migrator
    include SmoothMigrator
  end
end
