class Arcgis::CasesByDayWorker
  include Sidekiq::Worker

  def perform()
    get_time_series = HTTParty.get("https://services1.arcgis.com/CY1LXxl9zlJeBuRZ/arcgis/rest/services/Florida_COVID_19_Cases_by_Day_For_Time_Series/FeatureServer/0/query?f=json&where=Date%3Ctimestamp%20%272020-04-08%2004%3A00%3A00%27&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=ObjectId%2CFREQUENCY%2CDate&orderByFields=Date%20asc&outSR=102100&resultOffset=0&resultRecordCount=2000&cacheHint=true")
  
    if get_time_series.code == 200
      response = JSON.parse(get_time_series.body)

      series = []
      total = 0

      response["features"].each do |c|
        att = c["attributes"]

        find = series.find {|x| x[:date] == att["Date"].to_s}

        if find
          index = series.find_index(find)
          cases = (find[:cases] + att["FREQUENCY"])

          series[index][:cases] = cases

          total = series.inject(0) {|sum, hash| sum + hash[:cases]}
          series[index][:total] = total
        else
          total = series.inject(0) {|sum, hash| sum + hash[:cases]}
          cases = att["FREQUENCY"]
          series.push({date: att["Date"].to_s, cases: cases, total: (cases + total)})
        end
      end

      state = State.find_by_slug("florida")

      series.each do |s|
        date = Time.strptime(s[:date], '%Q')
        stat = StateStat.find_by_created_at(date.midnight..date.end_of_day)

        if stat.blank?
          state.state_stats.create(
            positive_residents: s[:total],
            created_at: date,
            updated_at: date
          )
        end
      end 

    end
  end
end