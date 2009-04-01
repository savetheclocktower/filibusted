class RenameCastVotesColumn < ActiveRecord::Migration
  def self.up
    rename_column :cast_votes, :cast_vote_id, :cloture_vote_id
  end

  def self.down
    rename_column :cast_votes, :cloture_vote_id, :cast_vote_id
  end
end
