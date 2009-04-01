class AddForeignKeysToVoteableTable < ActiveRecord::Migration
  def self.up
    add_column :voteables, :cloture_vote_id, :integer
  end

  def self.down
    remove_column :voteables, :cloture_vote_id
  end
end
