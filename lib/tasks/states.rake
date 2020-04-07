namespace :stat do
  task :states do
    doc = HTTParty.get("https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/Coronavirus_2019_nCoV_Cases/FeatureServer/1/query?where=Country_Region=%27US%27&outFields=*&outSR=4326&f=json")

    if doc.code == 200
      response = JSON.parse(doc.body)

      response["features"].each do |c|
        att = c["attributes"]
        state_slug = att["Province_State"].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')

        get_state = State.find_or_create_by(slug: state_slug) do |st|
          st.name = att["Province_State"]
          st.latitude = att["Lat"]
          st.longitude = att["Long_"]
        end
        
        last_stat = get_state.stats.last

        if state_slug != "florida"
          confirmed = att["Confirmed"]
          recovered = att["Recovered"]
          deaths = att["Deaths"]
          last_update = Time.strptime(att["Last_Update"].to_s, '%Q') rescue nil
          
          if last_stat.nil?
            get_state.stats.create(
              positive_residents: confirmed,
              deaths: deaths,
              recovered: recovered,
              last_update: last_update.to_s
            )
          else
            last_stat.update(
              positive_residents: confirmed,
              deaths: deaths,
              recovered: recovered,
              last_update: last_update.to_s
            )
          end
        end
      end
    end
  end
end
