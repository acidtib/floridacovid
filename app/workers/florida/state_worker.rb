class Florida::StateWorker
  include Sidekiq::Worker

  def perform()
    state = State.find_by_slug("florida")

    get_arc_state = HTTParty.get("https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/Coronavirus_2019_nCoV_Cases/FeatureServer/1/query?where=Province_State=%27Florida%27&outFields=OBJECTID,Province_State,Last_Update,Lat,Long_,Confirmed,Recovered,Deaths&outSR=4326&f=json", { read_timeout: 120 })
    if get_arc_state.code == 200
      response = JSON.parse(get_arc_state.body)
      
      unless response["error"]
        features = response["features"][0]

        recovered = features["attributes"]["Recovered"]

        state.state_stats.last.update(
          recovered: recovered
        )
      end
    end
  end

end