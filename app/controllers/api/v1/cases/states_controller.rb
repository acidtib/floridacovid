module Api
  module V1
    module Cases
      class StatesController < ApplicationController
        def index
          states = State.includes(:state_stats).all
      
          result = states.map.each do |s|
            stat = s.state_stats.last

            {
              name: s.name,
              confirmed: (stat.positive_residents + stat.positive_non_residents),
              recovered: stat.recovered,
              deaths: stat.deaths,
              latitude: s.lat,
              longitude: s.long,
              updated_at: stat.updated_at
            }
          end

          render json: result, status: 200
        end
      end
    end
  end
end