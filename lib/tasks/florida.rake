require "selenium-webdriver"

namespace :stat do
  task :florida do
    url = "https://arcg.is/0nHO11"
    
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--ignore-certificate-errors')
    options.add_argument('--disable-popup-blocking')
    options.add_argument('--disable-translate')

    if ENV["GOOGLE_CHROME_SHIM"]
      Selenium::WebDriver::Chrome.path = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
    end
    
    http_client = Selenium::WebDriver::Remote::Http::Default.new
    http_client.read_timeout = 120

    driver = Selenium::WebDriver.for :chrome, options: options, http_client: http_client
    driver.navigate.to(url)

    sleep(4)
    wait = Selenium::WebDriver::Wait.new(:timout => 500)
    wait.until { driver.find_element(:css, "div.dashboard-page") }

    if driver.title == "Florida COVID-19 Confirmed Cases"
      doc = Nokogiri::HTML(driver.page_source)

      florida_residents = doc.css("div#ember37 g.responsive-text-label text")[1].text.gsub(",", "")
      non_residents = doc.css("div#ember44 g.responsive-text-label text")[1].text.gsub(",", "")
      florida_deaths = doc.css("div#ember51 g.responsive-text-label text")[1].text.gsub(",", "")
      being_monitored = doc.css("div#ember58 g.responsive-text-label text")[1].text.gsub(",", "")

      total_tests = doc.css("div#ember80 g.responsive-text-label text")[1].text.gsub(",", "")
      pending_tests = doc.css("div#ember101 g.responsive-text-label text")[1].text.gsub(",", "")
      negative_tests = doc.css("div#ember94 g.responsive-text-label text")[1].text.gsub(",", "")

      state = State.find_or_create_by(slug: "florida") do |st|
        st.name = "Florida"
      end

      new_stat = state.stats.create(
        positive_residents: florida_residents.to_i,
        non_residents: non_residents.to_i,
        deaths: florida_deaths.to_i,
        results_negative: negative_tests.to_i,
        results_pending: pending_tests.to_i,
        being_monitored: being_monitored.to_i,
        last_update: Time.now()
      )

      driver.quit

      get_arc_state = HTTParty.get("https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/Coronavirus_2019_nCoV_Cases/FeatureServer/1/query?where=Province_State=%27Florida%27&outFields=OBJECTID,Province_State,Last_Update,Lat,Long_,Confirmed,Recovered,Deaths&outSR=4326&f=json")
      if get_arc_state.code == 200
        response = JSON.parse(get_arc_state.body)

        features = response["features"][0]

        recovered = features["attributes"]["Recovered"]

        new_stat.update(
          recovered: recovered
        )
      end

      get_ages = HTTParty.get("https://services1.arcgis.com/CY1LXxl9zlJeBuRZ/arcgis/rest/services/Florida_COVID19_Cases/FeatureServer/0/query?f=json&where=1%3D1&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&outStatistics=%5B%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_0_9%22%2C%22outStatisticFieldName%22%3A%22C_Age_0_9%22%7D%2C%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_10_19%22%2C%22outStatisticFieldName%22%3A%22C_Age_10_19%22%7D%2C%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_20_29%22%2C%22outStatisticFieldName%22%3A%22C_Age_20_29%22%7D%2C%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_30_39%22%2C%22outStatisticFieldName%22%3A%22C_Age_30_39%22%7D%2C%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_40_49%22%2C%22outStatisticFieldName%22%3A%22C_Age_40_49%22%7D%2C%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_50_59%22%2C%22outStatisticFieldName%22%3A%22C_Age_50_59%22%7D%2C%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_60_69%22%2C%22outStatisticFieldName%22%3A%22C_Age_60_69%22%7D%2C%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_70_79%22%2C%22outStatisticFieldName%22%3A%22C_Age_70_79%22%7D%2C%7B%22statisticType%22%3A%22sum%22%2C%22onStatisticField%22%3A%22C_Age_80plus%22%2C%22outStatisticFieldName%22%3A%22C_Age_80plus%22%7D%5D&outSR=102100&cacheHint=true")
      if get_ages.code == 200
        response = JSON.parse(get_ages.body)

        features = response["features"][0]["attributes"]

        new_stat.update(
          age_0_9: features["C_Age_0_9"],
          age_10_19: features["C_Age_10_19"],
          age_20_29: features["C_Age_20_29"],
          age_30_39: features["C_Age_30_39"],
          age_40_49: features["C_Age_40_49"],
          age_50_59: features["C_Age_50_59"],
          age_60_69: features["C_Age_60_69"],
          age_70_79: features["C_Age_70_79"],
          age_80plus: features["C_Age_80plus"]
        )
      end

      get_counties = HTTParty.get("https://services1.arcgis.com/CY1LXxl9zlJeBuRZ/arcgis/rest/services/Florida_Testing/FeatureServer/0/query?f=json&where=1%3D1&returnGeometry=true&spatialRel=esriSpatialRelIntersects&maxAllowableOffset=2445&geometry=%7B%22xmin%22%3A-10018754.171395395%2C%22ymin%22%3A2504688.5428502634%2C%22xmax%22%3A-8766409.899971206%2C%22ymax%22%3A3757032.8142744508%2C%22spatialReference%22%3A%7B%22wkid%22%3A102100%2C%22latestWkid%22%3A3857%7D%7D&geometryType=esriGeometryEnvelope&inSR=102100&outFields=*&outSR=102100&resultType=tile")
      if get_counties.code == 200
        response = JSON.parse(get_counties.body)

        response["features"].each do |c|
          att = c["attributes"]

          name = att["COUNTYNAME"].capitalize
          slug = att["COUNTYNAME"].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
          residents = att["C_FLRes"]
          non_residents = att["C_NotFLRes"]
          deaths = att["FLResDeaths"]
          last_update = Time.now()

          county = state.counties.find_or_create_by(slug: slug) do |ct|
            ct.name = name
          end

          county.update(
            residents: residents,
            non_residents: non_residents,
            deaths: deaths,
            last_update: last_update, 
          )
        end
      end
    else
      driver.quit
    end
  end
end
