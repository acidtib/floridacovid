class FloridaWorker
  include Sidekiq::Worker

  def perform()
    url = "https://experience.arcgis.com/experience/96dd742462124fa0b38ddedb9b25e429"

    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--ignore-certificate-errors')
    options.add_argument('--disable-popup-blocking')
    options.add_argument('--disable-translate')
    options.add_argument('--no-sandbox')

    Selenium::WebDriver::Chrome.path = ENV.fetch('GOOGLE_CHROME_SHIM', nil) if ENV["GOOGLE_CHROME_SHIM"]

    http_client = Selenium::WebDriver::Remote::Http::Default.new
    http_client.read_timeout = 240
    
    driver = Selenium::WebDriver.for :chrome, options: options, http_client: http_client
    driver.navigate.to(url)

    sleep(5)
    wait = Selenium::WebDriver::Wait.new(:timout => 500)
    wait.until { driver.find_element(:css, "div.dashboard-page") }

    if driver.title == "Florida COVID-19 Response for Mobile"
      doc = Nokogiri::HTML(driver.page_source)

      sleep(5)

      florida_residents = doc.at('text:contains("Positive Residents")').parent.parent.parent.parent.next_element.css("g.responsive-text-label text").text.gsub(",", "").to_i
      non_residents = doc.at('text:contains("Positive Non-Residents")').parent.parent.parent.parent.next_element.css("g.responsive-text-label text").text.gsub(",", "").to_i
      florida_deaths = doc.at('text:contains("Deaths")').parent.parent.parent.parent.next_element.css("g.responsive-text-label text").text.gsub(",", "").to_i
      being_monitored = doc.at('text:contains("Hospitalizations")').parent.parent.parent.parent.next_element.css("g.responsive-text-label text").text.gsub(",", "").to_i
      negative_tests = doc.at('text:contains("Negative")').parent.parent.parent.parent.next_element.css("g.responsive-text-label text").text.gsub(",", "").to_i
      results_total = (florida_residents + non_residents + negative_tests)

      state = State.find_by_slug("florida")
      last_stat = state.state_stats.today

      if last_stat.count == 0
        if state.state_stats.yesterday.last.positive_residents != florida_residents
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

      Florida::StateWorker.perform_async

      Florida::AgesWorker.perform_async

      Florida::CountiesWorker.perform_async

      driver.quit
    else
      driver.quit
    end
  end
end
