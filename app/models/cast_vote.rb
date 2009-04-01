class CastVote < ActiveRecord::Base
  belongs_to :cloture_vote
  belongs_to :senator  
end
