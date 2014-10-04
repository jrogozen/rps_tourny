#require 'sinatra'
require './app.rb'

run Sinatra::Application

configure :development do
  set :port, 9494
end