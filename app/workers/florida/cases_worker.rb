class Florida::CasesWorker
  include Sidekiq::Worker

  def perform(offset = 0)
    if offset == 0
      state = State.find_by_slug("florida")
      offset = (state.cases.last.object_id - 500)
    end

    get_cases = HTTParty.get("https://services1.arcgis.com/CY1LXxl9zlJeBuRZ/arcgis/rest/services/Florida_COVID19_Case_Line_Data_NEW/FeatureServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json&resultOffset=#{offset}&resultRecordCount=2000", { read_timeout: 120 })
    
    if get_cases.code == 200
      response = JSON.parse(get_cases.body)

      unless response["error"]
        cases = response["features"]
    
        cases.each do |c|
          Florida::ReadCaseWorker.perform_in(30.seconds, c["attributes"])
        end

        if response["exceededTransferLimit"]
          # paginate
          new_offset = cases.last["attributes"]["ObjectId"]
          
          Florida::CasesWorker.perform_async(new_offset)
        end
      end
    end
  end

end