class Florida::ReadCaseWorker
  include Sidekiq::Worker

  def perform(payload)
    state = State.find_by_slug("florida")

    county_name = payload["County"].capitalize
    slug = payload["County"].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')

    county = state.counties.find_or_create_by!(slug: slug) do |ct|
      ct.name = county_name
    end

    Case.find_or_create_by!(object_id: payload["ObjectId"]) do |c|
      c.county = county
      c.state = state
      c.age = payload["Age"]
      c.age_group = payload["Age_group"]
      c.case_ = payload["Case_"]
      c.contact = payload["Contact"]
      c.died = payload["Died"]
      c.ed_visit = payload["EDvisit"]
      c.gender = payload["Gender"]
      c.hospitalized = payload["Hospitalized"]
      c.jurisdiction = payload["Jurisdiction"]
      c.origin = payload["Origin"]
      c.travel_related = payload["Travel_related"]
      c.event_date = DateTime.strptime(payload["EventDate"].to_s,'%Q')
      c.case_date = DateTime.strptime(payload["Case1"].to_s,'%Q')
      c.chart_date = DateTime.strptime(payload["ChartDate"].to_s,'%Q')
    end
  end

end