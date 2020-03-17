require 'sinatra'
require 'sinatra/activerecord'
require 'rack/ssl-enforcer'
require 'sinatra/namespace'
require 'sinatra/cross_origin'

configure do
  enable :cross_origin
  set :protection, :except => [:json_csrf]
end

use Rack::SslEnforcer if production?

Dir["./models/*.rb"].each { |file| require file }

get '/' do
  @stats = State.find_by_slug("florida").stats.last
  @total = (@stats.positive_residents + @stats.non_residents + @stats.cases_repatriated)
  erb :home
end

namespace '/api/v1' do
  before do
    response.headers['Access-Control-Allow-Origin'] = '*'
    content_type 'application/json'
  end

  get '/cases' do
    stats = State.find_by_slug("florida").stats.last
    
    {
      "cases": {
        total: (stats.positive_residents + stats.non_residents + stats.cases_repatriated),
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
        currently: stats.being_monitored
      },
      last_update: stats.last_update
    }.to_json
  end

  options "*" do
    response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept"
    response.headers["Access-Control-Allow-Origin"] = "*"
    200
  end
end