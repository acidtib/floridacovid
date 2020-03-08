namespace :stat do
  task :floridahealth do
    doc = Nokogiri::HTML(open("http://www.floridahealth.gov/diseases-and-conditions/COVID-19/"))

    block =  doc.css("#content_container #main_column .split_70-30 .split_70-30_left block")

    florida_residents = block.at('div:contains("Florida Residents")').text.split("–").first.strip
    cases_repatriated = block.at('div:contains("Florida Cases Repatriated")').text.split("–").first.strip
    non_residents = block.at('div:contains("Non-Florida resident")').text.split("–").first.strip
    florida_deaths = block.at('h3:contains("Deaths")').next_element.text.split("–").first.strip
    negative_tests = block.at('h3:contains("Number of Negative Test Results")').next_element.text.strip
    pending_tests = block.at('h3:contains("Number of Pending Testing Results")').next_element.text.strip
    being_monitored = block.at('div:contains("currently being monitored")').text.split("–").first.strip
    total_monitored = block.at('div:contains("people monitored to date")').text.split("–").first.strip
    last_updated = block.at('sup:contains("as of")').text.gsub("as of ", "")

    state = State.find_by_slug("florida")
    state.stats.create(
      positive_residents: florida_residents.to_i,
      cases_repatriated: cases_repatriated.to_i,
      non_residents: non_residents.to_i,
      deaths: florida_deaths.to_i,
      results_negative: negative_tests.to_i,
      results_pending: pending_tests.to_i,
      being_monitored: being_monitored.to_i,
      total_monitored: total_monitored.to_i,
      last_update: last_update
    )
  end
end