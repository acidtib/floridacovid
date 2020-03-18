namespace :stat do
  task :arcgis do
    doc = HTTParty.get("https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/Coronavirus_2019_nCoV_Cases/FeatureServer/1/query?where=Country_Region=%27US%27&outFields=*&f=json")

    if doc.code == 200
      response = JSON.parse(doc.body)
      
      total_cases = 0
      total_recovered = 0
      total_deaths = 0

      response["features"].each do |f|

        att = f["attributes"]

        state = att["Province_State"]
        confirmed = att["Confirmed"]
        recovered = att["Recovered"]
        deaths = att["Deaths"]
        last_update = att["Last_Update"]

        total_cases = (total_cases + confirmed)
        total_recovered = (total_recovered + recovered)
        total_deaths = (total_deaths + deaths)
      end

      co = Country.find_by_slug("us")

      co.update(
        confirmed: total_cases,
        recovered: total_recovered,
        deaths: total_deaths
      )
    end
  end
end