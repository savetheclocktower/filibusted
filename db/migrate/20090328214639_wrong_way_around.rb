class WrongWayAround < ActiveRecord::Migration
  def self.up
    remove_column :voteables, :cloture_vote_id
    add_column :cloture_votes, :voteable_id, :integer
  end

  def self.down
    remove_column :cloture_votes, :voteable_id
    add_column :voteables, :cloture_vote_id, :integer
  end
end
