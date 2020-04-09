class PageController < ApplicationController
  def index
    @state = State.includes(:state_stats).find_by_slug("florida")
    @state_stats = @state.state_stats.today.last
    @state_stats_yesterday = @state.state_stats.yesterday.last
    @ages = @state.age_stats.last

    @countries = Country.includes(:country_stats).all
    @co_stats = @countries.find_by_slug("us").country_stats.last

    @earth_confirmed = 0
    @earth_recovered = 0
    @earth_deaths = 0
  
    @countries.each do |co|
      stat = co.country_stats.last

      @earth_confirmed += stat.confirmed
      @earth_recovered += stat.recovered
      @earth_deaths += stat.deaths
    end

    @counties = County.includes(:county_stats).order("county_stats.residents desc").limit(5)
  end

  def counties
    @counties = County.includes(:county_stats).order(:name).all
  end

  def api
    
  end
end
