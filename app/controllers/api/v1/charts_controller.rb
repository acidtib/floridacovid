module Api
  module V1
    class ChartsController < ApplicationController
      def cases
        state = State.find_by_slug("florida")
        stats = state.state_stats.all.order("created_at ASC")

        date_from = stats.first.created_at.to_date
        date_to = stats.last.created_at.to_date
        date_range = date_from..date_to
        total_per_day = []

        date_range.map {|d| Date.new(d.year, d.month, d.day) }.uniq.each do |d|
          stat = state.state_stats.where(created_at: d.midnight..d.end_of_day).last
          
          if stat
            total_per_day.push([ d, stat.positive_residents ])
          end
        end

        result = [
          {name: "Total Per Day", data: total_per_day, color: "#e64c00"}
        ]
        
        render json: result, status: 200
      end
    end
  end
end