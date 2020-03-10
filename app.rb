require 'sinatra'
require 'sinatra/activerecord'
require 'rack/ssl-enforcer'
require 'sinatra/namespace'

configure do
  set :protection, :except => [:json_csrf]
end

use Rack::SslEnforcer if production?

Dir["./models/*.rb"].each { |file| require file }

get '/' do
  @stats = State.find_by_slug("florida").stats.last
  erb :home
end

namespace '/api/v1' do
  before do
    content_type 'application/json'
  end

  get '/cases' do
    stats = State.find_by_slug("florida").stats.last
    
    {
      "cases": {
        residents: stats.positive_residents,
        repatriated: stats.cases_repatriated,
        non_residents: stats.non_residents,
      },
      "deaths": {
        residents: stats.deaths
      },
      "results": {
        negative: stats.results_negative,
        pending: stats.results_pending
      },
      "monitored": {
        currently: stats.being_monitored,
        total: stats.total_monitored
      },
      last_update: stats.last_update
    }.to_json
  end
end