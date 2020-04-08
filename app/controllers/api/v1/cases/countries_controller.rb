module Api
  module V1
    module Cases
      class CountriesController < ApplicationController
        def index
          countries = Country.includes(:country_stats).all
        
          result = countries.map.each do |m|
            stat = m.country_stats.last
            {
              name: m.name,
              confirmed: stat.confirmed,
              recovered: stat.recovered,
              deaths: stat.deaths,
              latitude: m.lat,
              longitude: m.long,
              updated_at: stat.updated_at
            }
          end

          render json: result, status: 200
        end
      end
    end
  end
end