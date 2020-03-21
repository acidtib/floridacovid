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
  @total = (@stats.positive_residents + @stats.non_residents)
  @co = Country.find_by_slug("us")

  erb :home
end

namespace '/api/v1' do
  before do
    response.headers['Access-Control-Allow-Origin'] = '*'
    content_type 'application/json'
  end

  get '/cases' do
    stats = State.find_by_slug("florida").stats.last
    co = Country.find_by_slug("us")
    
    {
      "cases": {
        total: (stats.positive_residents + stats.non_residents),
        residents: stats.positive_residents,
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
      "country": {
        name: "US",
        confirmed: co.confirmed,
        recovered: co.recovered,
        deaths: co.deaths
      },
      last_update: stats.last_update
    }.to_json
  end

  namespace '/cases' do
    get '/countries' do
      countries = Country.all
      
      results = countries.map.each do |m|
        {
          name: m.name,
          confirmed: m.confirmed,
          recovered: m.recovered,
          deaths: m.deaths,
          last_update: m.last_update
        }
      end

      results.to_json
    end

    get '/states' do
      states = State.all
      
      results = states.map.each do |s|
        stat = s.stats.last

        {
          name: s.name,
          confirmed: stat.positive_residents,
          recovered: stat.recovered,
          deaths: stat.deaths,
          last_update: stat.last_update
        }
      end

      results.to_json
    end
  end

  options "*" do
    response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept"
    response.headers["Access-Control-Allow-Origin"] = "*"
    200
  end
end