class StatesWorker
  include Sidekiq::Worker

  def perform()
    get_states = HTTParty.get("https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/Coronavirus_2019_nCoV_Cases/FeatureServer/1/query?where=Country_Region=%27US%27&outFields=*&outSR=4326&f=json")

    if get_states.code == 200
      response = JSON.parse(get_states.body)

      response["features"].each do |c|
        att = c["attributes"]
        state_slug = att["Province_State"].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
        
        next if state_slug == 'recovered'

        country = Country.find_by_slug("us")

        get_state = State.find_or_create_by(slug: state_slug) do |st|
          st.name = att["Province_State"]
          st.lat = att["Lat"]
          st.long = att["Long_"]
          st.country = country
        end

        last_stat = get_state.state_stats.today

        if state_slug != "florida"
          if last_stat.count == 0
            get_state.state_stats.create(
              positive_residents: att["Confirmed"],
              recovered: att["Recovered"],
              deaths: att["Deaths"]
            )
          else
            last_stat.last.update(
              positive_residents: att["Confirmed"],
              recovered: att["Recovered"],
              deaths: att["Deaths"]
            )
          end
        end
      end
    end
  end
end