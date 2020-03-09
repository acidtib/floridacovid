require 'sinatra'
require 'sinatra/activerecord'
require 'rack/ssl-enforcer'

use Rack::SslEnforcer if production?

Dir["./models/*.rb"].each { |file| require file }

get '/' do
  @stats = State.find_by_slug("florida").stats.last
  erb :home
end