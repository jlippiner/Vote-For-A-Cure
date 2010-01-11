require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class User < ActiveRecord::Base
end

class SmoothMigrationTest < Test::Unit::TestCase
  
  def setup
    SmoothMigration.exception_count = 0
  end
  
  def test_should_raise_immediately_when_disabled
    SmoothMigration.disabled = true
    assert_raises(ActiveRecord::StatementInvalid) do
      add_column_to_non_existent_table
    end
  ensure
    SmoothMigration.disabled = false
  end
  
  def test_should_write_exception_info_to_stdout
  end
  
  def test_should_not_raise_when_enabled
    assert_nothing_raised do
      add_column_to_non_existent_table
    end
  end
  
  def test_should_increment_count_on_failing_query
    add_column_to_non_existent_table
    assert_equal 1, SmoothMigration.exception_count
  end
  
  def test_capture_stdout
    output = capture_stdout do
      print 'test capture stdout'
    end
    assert_equal "test capture stdout", output
  end
  
  def test_should_say_exception_type_on_rescue
    output = capture_stdout { drop_non_existent_table }
    assert output.include?("  -> ActiveRecord::StatementInvalid"), output.inspect
  end
  
  def test_should_say_exception_message_on_rescue
    output = capture_stdout { drop_non_existent_table }
    assert output.detect { |line| line =~ /  -> .*Exception.* DROP TABLE does_not_exist.*/ }
  end
  
  def test_should_fail_migration_without_smoothness
    SmoothMigration.disabled = true
    assert_raises(ActiveRecord::StatementInvalid) { migrate_to_version(1) }
    assert_equal 0, schema_version
  ensure
    SmoothMigration.disabled = false
  end
  
  def test_should_disable_with_env_smooth
    ENV['SMOOTH'] = "false"
    assert_raises(ActiveRecord::StatementInvalid) { migrate_to_version(1) }
    assert SmoothMigration.disabled
  ensure
    SmoothMigration.disabled = false
    ENV['SMOOTH'] = nil
  end
  
  def test_should_migrate_capturing_failures
    assert_raises(ActiveRecord::FailedMigration) { migrate_to_version(1) }
    assert ActiveRecord::Base.connection.tables.include?("users")
  ensure
    migrate_to_version(0) rescue nil
  end
  
  def test_should_migrate_through_many_versions
    assert_raises(ActiveRecord::FailedMigration) { migrate_to_version(2) }
    assert_equal 2, schema_version
    assert User.table_exists?
    assert User.columns.detect { |c| c.name == "nickname" }
  ensure
    migrate_to_version(0) rescue nil
  end
  
  def add_column_to_non_existent_table
    silence_stdout { ActiveRecord::Migration.add_column :fake_table, :foo, :string }
  end
  
  def drop_non_existent_table
    ActiveRecord::Migration.drop_table :does_not_exist
  end
  
  def migrate_to_version(version)
    silence_stdout { ActiveRecord::Migrator.migrate(File.dirname(__FILE__) + '/migrations', version) }
  end
  
  def schema_version
    ActiveRecord::Migrator.current_version
  end

end
