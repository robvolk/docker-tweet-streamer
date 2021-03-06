require "sinatra"
require "slim"
require "mongoid"
require_relative "models/tweet.rb"

# Bind Sinatra to this IP instead of the default, localhost, to run on Docker
set :bind, '0.0.0.0'

Mongoid.load!("mongoid.yml")

get '/' do
  @io_url = ENV["STREAMER_URL"]
  @tweets = Tweet.gt(created_at: Date.today - 7).limit(10)

  slim :index
end

post '/' do
  status 400 if params[:tweet].nil?

  Tweet.create!(params[:tweet])
end

get '/kill' do
  Tweet.delete_all
end
