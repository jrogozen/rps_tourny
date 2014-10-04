require 'active_record'
require 'active_record_tasks'
require_relative '../lib/rps.rb'
# require_relative '../app.rb' # the path to your application file

ActiveRecord::Base.establish_connection(
  :adapter => 'postgresql',
  :database => 'rps'
) 