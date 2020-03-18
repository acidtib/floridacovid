namespace :stat do
  task :countries do
    doc = HTTParty.get("https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/Coronavirus_2019_nCoV_Cases/FeatureServer/2/query?where=1%3D1&outFields=*&outSR=4326&f=json")

    if doc.code == 200
      response = JSON.parse(doc.body)

      response["features"].each do |c|
        att = c["attributes"]
        co_slug = att["Country_Region"].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')

        get_country = Country.find_or_create_by(slug: co_slug) do |co|
          co.name = att["Country_Region"]
        end

        confirmed = att["Confirmed"]
        recovered = att["Recovered"]
        deaths = att["Deaths"]
        last_update = Time.strptime(att["Last_Update"].to_s, '%Q')

        get_country.update(
          confirmed: confirmed,
          recovered: recovered,
          deaths: deaths,
          last_update: last_update
        )
      end
    end
  end
end