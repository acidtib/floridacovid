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

      state.stats.create(
        positive_residents: florida_residents.to_i,
        non_residents: non_residents.to_i,
        deaths: florida_deaths.to_i,
        results_negative: negative_tests.to_i,
        results_pending: pending_tests.to_i,
        being_monitored: being_monitored.to_i,
        last_update: Time.now()
      )

      # TODO: get Recovered numbers
      # https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/Coronavirus_2019_nCoV_Cases/FeatureServer/1/query?where=Province_State=%27Florida%27&outFields=OBJECTID,Province_State,Last_Update,Lat,Long_,Confirmed,Recovered,Deaths&outSR=4326&f=json
    end

    driver.quit
  end
end
