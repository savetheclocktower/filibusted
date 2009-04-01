class WelcomeController < ApplicationController
  
  def index
    @recent  = ClotureVote.recent
    @notable = Senator.all_by_obstruction_rate[0..2]
  end
  
end
