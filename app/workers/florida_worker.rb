class FloridaWorker
  include Sidekiq::Worker

  def perform()
    cases = Case.all
    
    florida_residents = cases.where(jurisdiction: "FL resident").count
    non_residents = cases.where(jurisdiction: "Non-FL resident").count
    florida_deaths = cases.where(died: "Yes").count
    being_monitored = cases.where(hospitalized: "YES").count
    results_total = (florida_residents + non_residents)

    state = State.find_by_slug("florida")
    last_stat = state.state_stats.today

    if last_stat.count == 0
      if state.state_stats.yesterday.last.positive_residents != florida_residents
        state.state_stats.create(
          positive_residents: florida_residents,
          positive_non_residents: non_residents,
          deaths: florida_deaths,
          results_total: results_total,
          being_monitored: being_monitored
        )
      end
    else
      last_stat.last.update(
        positive_residents: florida_residents,
        positive_non_residents: non_residents,
        deaths: florida_deaths,
        results_total: results_total,
        being_monitored: being_monitored
      )
    end

    Florida::AgesWorker.perform_async

    Florida::CountiesWorker.perform_async
  end
end
