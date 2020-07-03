class Florida::CasesWorker
  include Sidekiq::Worker

  def perform()
    resultOffset = 0

    request(resultOffset)
  end

  def request(offset)
    get_cases = HTTParty.get("https://services1.arcgis.com/CY1LXxl9zlJeBuRZ/arcgis/rest/services/Florida_COVID19_Case_Line_Data_NEW/FeatureServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json&resultOffset=#{offset}&resultRecordCount=2000", { read_timeout: 120 })
    
    if get_cases.code == 200
      response = JSON.parse(get_cases.body)

      unless response["error"]
        read_cases(response)
      end
    end
  end

  def read_cases(payload)
    cases = payload["features"]

    if payload["exceededTransferLimit"]
      # paginate
      new_offset = cases.last["attributes"]["ObjectId"]
      request(new_offset)
    else
      cases.each do |c|
        Florida::ReadCaseWorker.perform_in(5.seconds, c["attributes"])
      end
    end
  end

end