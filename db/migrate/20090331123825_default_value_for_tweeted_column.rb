class DefaultValueForTweetedColumn < ActiveRecord::Migration
  def self.up
    change_column_default :cloture_votes, :tweeted, false
  end

  def self.down
  end
end
