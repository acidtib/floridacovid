class FloridaWorker
  include Sidekiq::Worker

  def perform()
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

    sleep(5)
    wait = Selenium::WebDriver::Wait.new(:timout => 500)
    wait.until { driver.find_element(:css, "div.dashboard-page") }

    if driver.title == "Florida COVID-19 Confirmed Cases"
      doc = Nokogiri::HTML(driver.page_source)

      florida_residents = doc.css("div#ember38 g.responsive-text-label text")[1].text.gsub(",", "")
      non_residents = doc.css("div#ember153 g.responsive-text-label text")[1].text.gsub(",", "")
      florida_deaths = doc.css("div#ember52 g.responsive-text-label text")[1].text.gsub(",", "")
      being_monitored = doc.css("div#ember45 g.responsive-text-label text")[1].text.gsub(",", "")
      negative_tests = doc.css("div#ember103 g.responsive-text-label text")[1].text.gsub(",", "")

      state = State.find_by_slug("florida")
      last_stat = state.state_stats.today

      if last_stat.count == 0
        fresh_stat = state.state_stats.create(
          positive_residents: florida_residents.to_i,
          positive_non_residents: non_residents.to_i,
          deaths: florida_deaths.to_i,
          results_total: (florida_residents.to_i + non_residents.to_i + negative_tests.to_i)
          results_negative: negative_tests.to_i,
          being_monitored: being_monitored.to_i
        )
      else
        fresh_stat = last_stat.last.update(
          positive_residents: florida_residents.to_i,
          positive_non_residents: non_residents.to_i,
          deaths: florida_deaths.to_i,
          results_total: (florida_residents.to_i + non_residents.to_i + negative_tests.to_i)
          results_negative: negative_tests.to_i,
          being_monitored: being_monitored.to_i
        )
      end

      get_arc_state = HTTParty.get("https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/Coronavirus_2019_nCoV_Cases/FeatureServer/1/query?where=Province_State=%27Florida%27&outFields=OBJECTID,Province_State,Last_Update,Lat,Long_,Confirmed,Recovered,Deaths&outSR=4326&f=json")
      if get_arc_state.code == 200
        response = JSON.parse(get_arc_state.body)
        
        unless response["error"]
          features = response["features"][0]

          recovered = features["attributes"]["Recovered"]

          fresh_stat.update(
            recovered: recovered
          )
        end
      end
    else
      driver.quit
    end
  end
end