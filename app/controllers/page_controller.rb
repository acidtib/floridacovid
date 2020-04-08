class PageController < ApplicationController
  def index
    @state = State.find_by_slug("florida")
    @state_stats = @state.state_stats.last
    @ages = @state.age_stats.last
  end
end
