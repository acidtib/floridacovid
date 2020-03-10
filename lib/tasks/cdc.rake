require "httparty"
require "json"

namespace :stat do
  task :cdc do
    doc = HTTParty.get("https://www.cdc.gov/coronavirus/2019-ncov/map-cases-us.json")

    if doc.code == 200
      response = JSON.parse(doc.body)

      response["data"].each do |state|
        if state["Name"] != nil
          slug = state["Name"].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
          
          get_state = State.find_or_create_by(slug: slug) do |st|
            st.name = state["Name"]
          end
          
          if slug != "florida"
            get_state.stats.create(
              positive_residents: state["Cases Reported"].to_i
            )
          end
        end
      end
    end
  end
end