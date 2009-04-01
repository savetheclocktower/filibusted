class VotesController < ApplicationController
  
  
  def show
    id = params[:id]
    
    if (id.include?("-"))
      @vote = ClotureVote.find_by_govtrack_id(id)
    else
      @vote = ClotureVote.find(params[:id])
    end
    
  end
  
end
