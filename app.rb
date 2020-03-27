require 'sinatra'
require 'sinatra/activerecord'
require 'rack/ssl-enforcer'
require 'sinatra/namespace'
require 'sinatra/cross_origin'
require 'i18n'
require 'i18n/backend/fallbacks'

configure do
  I18n.enforce_available_locales = true
  I18n.default_locale = "en"
  I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
  I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
  I18n.backend.load_translations

  enable :cross_origin
  set :protection, :except => [:json_csrf]
end

use Rack::SslEnforcer if production?

Dir["./models/*.rb"].each { |file| require file }

before '/:locale*' do
  unless params[:locale] == "api"
    I18n.locale = params[:locale] || I18n.default_locale
    request.path_info = '/' + params[:splat ][0]
  end
end

get '/(.:locale)?' do
  @state = State.find_by_slug("florida")
  @stats = @state.stats.last
  @total = (@stats.positive_residents + @stats.non_residents)
  @counties = @state.counties.order(:name).all
  @earth = Country.all
  @co = @earth.find_by_slug("us")

  erb :home
end

namespace '/api/v1' do
  before do
    response.headers['Access-Control-Allow-Origin'] = '*'
    content_type 'application/json'
  end

  get '/cases' do
    state = State.find_by_slug("florida")
    stats = state.stats.last
    co = Country.find_by_slug("us")
    
    {
      name: state.name,
      latitude: state.latitude,
      longitude: state.longitude,
      "cases": {
        total: (stats.positive_residents + stats.non_residents),
        residents: stats.positive_residents,
        non_residents: stats.non_residents,
        recovered: stats.recovered
      },
      "deaths": {
        residents: stats.deaths
      },
      "results": {
        total: (stats.results_negative + stats.positive_residents + stats.non_residents + stats.results_pending),
        negative: stats.results_negative,
        pending: stats.results_pending
      },
      "monitored": {
        currently: stats.being_monitored
      },
      "ages": {
        "0_4": stats.age_0_4, 
        "5_14": stats.age_5_14, 
        "15_24": stats.age_15_24, 
        "25_34": stats.age_25_34, 
        "35_44": stats.age_35_44, 
        "45_54": stats.age_45_54, 
        "55_64": stats.age_55_64, 
        "65_74": stats.age_65_74, 
        "75_84": stats.age_75_84,
        "85plus": stats.age_85plus
      },
      "country": {
        name: "US",
        confirmed: co.confirmed,
        recovered: co.recovered,
        deaths: co.deaths,
        latitude: co.latitude,
        longitude: co.longitude,
        last_update: co.last_update
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
          latitude: m.latitude,
          longitude: m.longitude,
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
          latitude: s.latitude,
          longitude: s.longitude,
          last_update: stat.last_update
        }
      end

      results.to_json
    end

    get '/earth' do
      countries = Country.all
      
      {
        name: "Earth",
        confirmed: number_with_delimiter(countries.sum(:confirmed)),
        recovered: number_with_delimiter(countries.sum(:recovered)),
        deaths: number_with_delimiter(countries.sum(:deaths)),
        latitude: "+90",
        longitude: "0",
        last_update: countries.first.last_update
      }.to_json
    end

    get '/counties' do
      state = State.find_by_slug("florida")
      counties = state.counties.order(:name).all
      
      results = counties.map.each do |c|
        {
          name: c.name,
          total: number_with_delimiter((c.residents + c.non_residents)),
          residents: number_with_delimiter(c.residents),
          non_residents: number_with_delimiter(c.non_residents),
          deaths: number_with_delimiter(c.deaths),
          last_update: c.last_update
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

helpers do
  def number_with_delimiter(num)
    num.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end
end