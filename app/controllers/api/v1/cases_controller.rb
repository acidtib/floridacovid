module Api
  module V1
    class CasesController < ApplicationController
      def cases
        state = State.find_by_slug("florida")
        stats = state.state_stats.last
        ages = state.age_stats.last
        co = Country.find_by_slug("us")
        co_stats = co.country_stats.last

        result = {
          name: state.name,
          latitude: state.lat,
          longitude: state.long,
          "cases": {
            total: (stats.positive_residents + stats.positive_non_residents),
            residents: stats.positive_residents,
            non_residents: stats.positive_non_residents,
            recovered: stats.recovered
          },
          "deaths": {
            residents: stats.deaths
          },
          "results": {
            total: stats.results_total,
            negative: stats.results_negative,
          },
          "monitored": {
            currently: stats.being_monitored
          },
          "ages": {
            "0_4": ages.a_0_4, 
            "5_14": ages.a_5_14, 
            "15_24": ages.a_15_24, 
            "25_34": ages.a_25_34, 
            "35_44": ages.a_35_44, 
            "45_54": ages.a_45_54, 
            "55_64": ages.a_55_64, 
            "65_74": ages.a_65_74, 
            "75_84": ages.a_75_84,
            "85plus": ages.a_85plus
          },
          "country": {
            name: "US",
            confirmed: co_stats.confirmed,
            recovered: co_stats.recovered,
            deaths: co_stats.deaths,
            latitude: co.lat,
            longitude: co.long,
          },
          updated_at: stats.updated_at
        }

        render json: result, status: 200
      end
    end
  end
end