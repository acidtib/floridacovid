namespace :stat do
  task :florida do
    doc = HTTParty.get("https://services1.arcgis.com/CY1LXxl9zlJeBuRZ/arcgis/rest/services/Florida_Data/FeatureServer/0/query?f=json&where=1%3D1&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&resultOffset=0&resultRecordCount=50&cacheHint=true")
    
    if doc.code == 200
      response = JSON.parse(doc.body)

      data = response["features"][0]["attributes"]

      florida_residents = data["FloridaCases"]
      cases_repatriated = data["ResidentsOut"]
      non_residents = data["NResIN"]
      florida_deaths = data["Deaths"]
      negative_tests = data["Negative"]
      pending_tests = data["Pending"]
      being_monitored = data["MonitoredC"]
      total_monitored = data["MonitoredT"]
      
      state = State.find_by_slug("florida")
      state.stats.create(
        positive_residents: florida_residents.to_i,
        cases_repatriated: cases_repatriated.to_i,
        non_residents: non_residents.to_i,
        deaths: florida_deaths.to_i,
        results_negative: negative_tests.to_i,
        results_pending: pending_tests.to_i,
        being_monitored: being_monitored.to_i,
        total_monitored: total_monitored.to_i,
        last_update: Time.now()
      )
    end
  end
end
