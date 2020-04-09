module Api
  module V1
    module Cases
      class CountiesController < ApplicationController
        def index
          state = State.find_by_slug("florida")
          counties = state.counties.includes(:county_stats).order(:name).all
          
          result = counties.map.each do |c|
            stat = c.county_stats.last
            {
              name: c.name,
              total: (stat.residents + stat.non_residents),
              residents: stat.residents,
              non_residents: stat.non_residents,
              deaths: stat.deaths,
              updated_at: stat.updated_at
            }
          end

          render json: result, status: 200
        end
      end
    end
  end
end