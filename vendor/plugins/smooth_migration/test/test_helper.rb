$:.unshift(File.dirname(__FILE__) + '/../lib')
RAILS_ROOT = File.dirname(__FILE__)

require 'rubygems'
require 'test/unit'
require 'active_record'
require 'active_support/binding_of_caller'
require 'active_support/breakpoint'

ActiveRecord::Base.configurations['test'] = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'][ENV['DB'] || 'sqlite3'])

require 'smooth_migration'
require 'smooth_migrator'
require "#{File.dirname(__FILE__)}/../init"
load(File.dirname(__FILE__) + "/schema.rb") if File.exist?(File.dirname(__FILE__) + "/schema.rb")

class Test::Unit::TestCase #:nodoc:
  def silence_stdout
    silence_stream(STDOUT) { yield }
  end
  
  def capture_stdout
    old_stdout, $stdout = $stdout, StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = old_stdout
  end
end
