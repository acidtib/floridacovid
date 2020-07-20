class Florida::ReadCaseWorker
  include Sidekiq::Worker

  def perform(payload)
    state = State.find_by_slug("florida")

    county_name = payload["County"].capitalize
    slug = payload["County"].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')

    slug = "miami-dade" if slug == "dade"

    county = state.counties.find_or_create_by!(slug: slug) do |ct|
      ct.name = county_name
    end

    find_case = Case.find_by_object_id(payload["ObjectId"])

    if find_case
      Case.update(
        case_: payload["Case_"],
        contact: payload["Contact"],
        died: payload["Died"],
        ed_visit: payload["EDvisit"],
        hospitalized: payload["Hospitalized"],
        origin: payload["Origin"],
        travel_related: payload["Travel_related"],
        jurisdiction: payload["Jurisdiction"]
      )
    else
      Case.create!(
        county: county,
        state: state,
        age: payload["Age"],
        age_group: payload["Age_group"],
        case_: payload["Case_"],
        contact: payload["Contact"],
        died: payload["Died"],
        ed_visit: payload["EDvisit"],
        gender: payload["Gender"],
        hospitalized: payload["Hospitalized"],
        jurisdiction: payload["Jurisdiction"],
        origin: payload["Origin"],
        travel_related: payload["Travel_related"],
        event_date: DateTime.strptime(payload["EventDate"].to_s,'%Q'),
        case_date: DateTime.strptime(payload["Case1"].to_s,'%Q'),
        chart_date: DateTime.strptime(payload["ChartDate"].to_s,'%Q')
      )
    end

  end

end