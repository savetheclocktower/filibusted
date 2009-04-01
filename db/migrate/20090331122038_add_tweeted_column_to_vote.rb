class AddTweetedColumnToVote < ActiveRecord::Migration
  def self.up
    add_column :cloture_votes, :tweeted, :boolean
  end

  def self.down
    remove_column :cloture_votes, :tweeted
  end
end
