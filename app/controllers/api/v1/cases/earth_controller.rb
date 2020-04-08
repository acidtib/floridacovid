module Api
  module V1
    module Cases
      class EarthController < ApplicationController
        def index
          countries = Country.includes(:country_stats).all
          
          confirmed = 0
          recovered = 0
          deaths = 0
    
          countries.each do |co|
            stat = co.country_stats.last

            confirmed += stat.confirmed
            recovered += stat.recovered
            deaths += stat.deaths
          end

          result = {
            name: "Earth",
            confirmed: confirmed,
            recovered: recovered,
            deaths: deaths,
            latitude: "+90",
            longitude: "0"
          }

          render json: result, status: 200
        end
      end
    end
  end
end