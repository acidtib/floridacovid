module Api
  module V1
    class ChartsController < ApplicationController
      def cases
        state = State.find_by_slug("florida")
        stats = state.state_stats.all.order("created_at ASC")

        date_from = stats.first.created_at.to_date
        date_to = stats.last.created_at.to_date
        date_range = date_from..date_to

        puts date_range

        date_months = date_range.map {|d| Date.new(d.year, d.month, d.day) }.uniq.map do |date|
          stat = state.state_stats.find_by_created_at(date.midnight..date.end_of_day)
          puts date
          puts stat.inspect
          {
            # date => stat.positive_residents
          }
        end

        puts date_months

        # render json: date_months.reduce({}, :merge)
        render json: {}, status: 200
      end
    end
  end
end