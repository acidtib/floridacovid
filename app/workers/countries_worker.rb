class CountriesWorker
  include Sidekiq::Worker

  def perform()
    get_countries = HTTParty.get("https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/Coronavirus_2019_nCoV_Cases/FeatureServer/2/query?where=1%3D1&outFields=*&outSR=4326&f=json")

    if get_countries.code == 200
      response = JSON.parse(get_countries.body)

      response["features"].each do |c|
        att = c["attributes"]
        co_slug = att["Country_Region"].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')

        get_country = Country.find_or_create_by(slug: co_slug) do |co|
          co.name = att["Country_Region"]
          co.lat = att["Lat"]
          co.long = att["Long_"]
        end

        last_stat = get_country.country_stats.today

        if last_stat.count == 0
          get_country.country_stats.create(
            confirmed: att["Confirmed"],
            recovered: att["Recovered"],
            deaths: att["Deaths"]
          )
        else
          last_stat.last.update(
            confirmed: att["Confirmed"],
            recovered: att["Recovered"],
            deaths: att["Deaths"]
          )
        end
      end
    end
  end
end