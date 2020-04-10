class FloridaWorker
  include Sidekiq::Worker

  def perform()
    url = "https://arcg.is/0nHO11"

    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--ignore-certificate-errors')
    options.add_argument('--disable-popup-blocking')
    options.add_argument('--disable-translate')

    Selenium::WebDriver::Chrome.path = ENV.fetch('GOOGLE_CHROME_SHIM', nil) if ENV["GOOGLE_CHROME_SHIM"]

    http_client = Selenium::WebDriver::Remote::Http::Default.new
    http_client.read_timeout = 120
    
    driver = Selenium::WebDriver.for :chrome, options: options, http_client: http_client
    driver.navigate.to(url)

    sleep(5)
    wait = Selenium::WebDriver::Wait.new(:timout => 500)
    wait.until { driver.find_element(:css, "div.dashboard-page") }

    if driver.title == "Florida COVID-19 Confirmed Cases"
      doc = Nokogiri::HTML(driver.page_source)

      florida_residents = doc.at('text:contains("Positive Residents")').parent.parent.parent.parent.next_element.css("g.responsive-text-label text").text.gsub(",", "").to_i
      non_residents = doc.at('text:contains("Non-Residents")').parent.parent.parent.parent.next_element.css("g.responsive-text-label text").text.gsub(",", "").to_i
      florida_deaths = doc.at('text:contains("Deaths")').parent.parent.parent.parent.next_element.css("g.responsive-text-label text").text.gsub(",", "").to_i
      being_monitored = doc.at('text:contains("Hospitalizations")').parent.parent.parent.parent.next_element.css("g.responsive-text-label text").text.gsub(",", "").to_i
      negative_tests = doc.at('text:contains("Negative")').parent.parent.parent.parent.next_element.css("g.responsive-text-label text").text.gsub(",", "").to_i
      results_total = (florida_residents + non_residents + negative_tests)

      state = State.find_by_slug("florida")
      last_stat = state.state_stats.today

      if last_stat.count == 0
        if last_stat.positive_residents != florida_residents
          state.state_stats.create(
            positive_residents: florida_residents,
            positive_non_residents: non_residents,
            deaths: florida_deaths,
            results_total: results_total,
            results_negative: negative_tests,
            being_monitored: being_monitored
          )
        end
      else
        last_stat.last.update(
          positive_residents: florida_residents,
          positive_non_residents: non_residents,
          deaths: florida_deaths,
          results_total: results_total,
          results_negative: negative_tests,
          being_monitored: being_monitored
        )
      end

      get_arc_state = HTTParty.get("https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/Coronavirus_2019_nCoV_Cases/FeatureServer/1/query?where=Province_State=%27Florida%27&outFields=OBJECTID,Province_State,Last_Update,Lat,Long_,Confirmed,Recovered,Deaths&outSR=4326&f=json")
      if get_arc_state.code == 200
        response = JSON.parse(get_arc_state.body)
        
        unless response["error"]
          features = response["features"][0]

          recovered = features["attributes"]["Recovered"]

          state.state_stats.today.last.update(
            recovered: recovered
          )
        end
      end

      get_ages = HTTParty.get("https://services1.arcgis.com/CY1LXxl9zlJeBuRZ/arcgis/rest/services/Florida_COVID19_Cases/FeatureServer/0/query?f=json&where=1%3D1&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&outStatistics=%5B%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_0_4%22%2C%22outStatisticFieldName%22%3A%22C_Age_0_4%22%7D%2C%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_5_14%22%2C%22outStatisticFieldName%22%3A%22C_Age_5_14%22%7D%2C%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_15_24%22%2C%22outStatisticFieldName%22%3A%22C_Age_15_24%22%7D%2C%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_25_34%22%2C%22outStatisticFieldName%22%3A%22C_Age_25_34%22%7D%2C%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_35_44%22%2C%22outStatisticFieldName%22%3A%22C_Age_35_44%22%7D%2C%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_45_54%22%2C%22outStatisticFieldName%22%3A%22C_Age_45_54%22%7D%2C%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_55_64%22%2C%22outStatisticFieldName%22%3A%22C_Age_55_64%22%7D%2C%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_65_74%22%2C%22outStatisticFieldName%22%3A%22C_Age_65_74%22%7D%2C%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_75_84%22%2C%22outStatisticFieldName%22%3A%22C_Age_75_84%22%7D%2C%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_85plus%22%2C%22outStatisticFieldName%22%3A%22C_Age_85plus%22%7D%5D&cacheHint=true")
      if get_ages.code == 200
        response = JSON.parse(get_ages.body)

        unless response["error"]
          last_age_stat = state.age_stats.today

          features = response["features"][0]["attributes"]

          if last_age_stat.count == 0
            state.age_stats.create(
              a_0_4: features["C_Age_0_4"],
              a_5_14: features["C_Age_5_14"],
              a_15_24: features["C_Age_15_24"],
              a_25_34: features["C_Age_25_34"],
              a_35_44: features["C_Age_35_44"],
              a_45_54: features["C_Age_45_54"],
              a_55_64: features["C_Age_55_64"],
              a_65_74: features["C_Age_65_74"],
              a_75_84: features["C_Age_75_84"],
              a_85plus: features["C_Age_85plus"]
            )
          else
            last_age_stat.last.update(
              a_0_4: features["C_Age_0_4"],
              a_5_14: features["C_Age_5_14"],
              a_15_24: features["C_Age_15_24"],
              a_25_34: features["C_Age_25_34"],
              a_35_44: features["C_Age_35_44"],
              a_45_54: features["C_Age_45_54"],
              a_55_64: features["C_Age_55_64"],
              a_65_74: features["C_Age_65_74"],
              a_75_84: features["C_Age_75_84"],
              a_85plus: features["C_Age_85plus"]
            )
          end
        end
      end

      get_counties = HTTParty.get("https://services1.arcgis.com/CY1LXxl9zlJeBuRZ/arcgis/rest/services/Florida_Testing/FeatureServer/0/query?f=json&where=1%3D1&returnGeometry=true&spatialRel=esriSpatialRelIntersects&maxAllowableOffset=2445&geometry=%7B%22xmin%22%3A-10018754.171395395%2C%22ymin%22%3A2504688.5428502634%2C%22xmax%22%3A-8766409.899971206%2C%22ymax%22%3A3757032.8142744508%2C%22spatialReference%22%3A%7B%22wkid%22%3A102100%2C%22latestWkid%22%3A3857%7D%7D&geometryType=esriGeometryEnvelope&inSR=102100&outFields=*&outSR=102100&resultType=tile")
      if get_counties.code == 200
        response = JSON.parse(get_counties.body)

        unless response["error"]
          response["features"].each do |c|
            att = c["attributes"]
            
            name = att["COUNTYNAME"].capitalize
            slug = att["COUNTYNAME"].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
            residents = att["C_FLRes"]
            non_residents = att["C_NotFLRes"]
            deaths = att["FLResDeaths"]

            county = state.counties.find_or_create_by(slug: slug) do |ct|
              ct.name = name
            end
            
            last_county_stat = county.county_stats.today
            puts county.inspect
            
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

      driver.quit
    else
      driver.quit
    end
  end
end
