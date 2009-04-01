class SenatorsController < ApplicationController
  
  def index
    list
    render :action => :list
  end
  
  def show
    @senator = Senator.find_by_govtrack_id(params[:id])
    @meeting = Meeting.find_by_ordinal(111)
  end
  
  def list
    @senators = Senator.all_by_obstruction_rate.select(&:in_office?)
    
    @hall_of_blame     = Senator.hall_of_blame
    @best_in_minority  = Senator.best_in_minority
    @worst_in_majority = Senator.worst_in_majority
    @vulnerable        = Senator.most_vulnerable
  end
  
end
