class PageController < ApplicationController
  def index
    @state = State.includes(:state_stats).find_by_slug("florida")
    @state_stats = @state.state_stats.today.last
    if @state_stats
      @state_stats_yesterday = @state.state_stats.yesterday.last
    else
      @state_stats = @state.state_stats.yesterday.last
      @state_stats_yesterday = @state.state_stats.where(created_at: (Time.zone.yesterday - 24.hours).all_day).last
    end
    @ages = @state.age_stats.last

    @countries = Country.includes(:country_stats).all
    @co_stats = @countries.find_by_slug("us").country_stats.last

    @earth_confirmed = 0
    @earth_recovered = 0
    @earth_deaths = 0
  
    @countries.each do |co|
      stat = co.country_stats.last

      if stat
        @earth_confirmed += stat.confirmed
        @earth_recovered += stat.recovered
        @earth_deaths += stat.deaths
      end
    end

    @counties = County.includes(:county_stats).where.not(slug: "unknown").order("county_stats.residents desc").limit(5)
  end

  def counties
    @counties = County.includes(:county_stats).where.not(slug: "unknown").order("county_stats.residents desc")
  end

  def states
    @country = Country.includes(:country_stats).find_by_slug("us")
    @country_stats = @country.country_stats.today.last
    @country_stats_yesterday = @country.country_stats.yesterday.last

    @states = State.includes(:state_stats).order("state_stats.positive_residents desc").all
  end

  def earth
    @countries = Country.includes(:country_stats).order("country_stats.confirmed desc").all
    @country_stats = {
      today: {
        confirmed: 0,
        recovered: 0,
        deaths: 0
      },
      yesterday: {
        confirmed: 0,
        recovered: 0,
        deaths: 0
      }
    }
    @countries.each do |c|
      stat = c.country_stats.today.last
      stat_yesterday = c.country_stats.yesterday.last

      @country_stats[:today][:confirmed] += stat.confirmed
      @country_stats[:today][:recovered] += stat.recovered
      @country_stats[:today][:deaths] += stat.deaths
      @country_stats[:yesterday][:confirmed] += stat_yesterday.confirmed
      @country_stats[:yesterday][:recovered] += stat_yesterday.recovered
      @country_stats[:yesterday][:deaths] += stat_yesterday.deaths
    end
  end

  def api
    
  end
end
