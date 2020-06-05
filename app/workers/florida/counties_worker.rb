class Florida::CountiesWorker
  include Sidekiq::Worker

  def perform()
    state = State.find_by_slug("florida")

    get_counties = HTTParty.get("https://services1.arcgis.com/CY1LXxl9zlJeBuRZ/arcgis/rest/services/Florida_Testing/FeatureServer/0/query?f=json&where=1%3D1&returnGeometry=true&spatialRel=esriSpatialRelIntersects&maxAllowableOffset=2445&geometry=%7B%22xmin%22%3A-10018754.171395395%2C%22ymin%22%3A2504688.5428502634%2C%22xmax%22%3A-8766409.899971206%2C%22ymax%22%3A3757032.8142744508%2C%22spatialReference%22%3A%7B%22wkid%22%3A102100%2C%22latestWkid%22%3A3857%7D%7D&geometryType=esriGeometryEnvelope&inSR=102100&outFields=*&outSR=102100&resultType=tile", { read_timeout: 120 })
    if get_counties.code == 200
      response = JSON.parse(get_counties.body)

      unless response["error"]
        response["features"].each do |c|
          att = c["attributes"]
          
          name = att["COUNTYNAME"].capitalize
          slug = att["COUNTYNAME"].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
          residents = att["C_FLRes"]
          non_residents = att["C_NotFLRes"]
          deaths = att["Deaths"]

          county = state.counties.find_or_create_by(slug: slug) do |ct|
            ct.name = name
          end
          
          last_county_stat = county.county_stats.today
          
          if last_county_stat.count == 0
            county.county_stats.create(
              residents: residents,
              non_residents: non_residents,
              deaths: deaths
            )
          else
            last_county_stat.last.update(
              residents: residents,
              non_residents: non_residents,
              deaths: deaths
            )
          end
        end
      end
    end
  end

end