#require 'sinatra'
require './app.rb'

run Sinatra::Application

configure do
  set :port, 9494
  enable :sessions
end