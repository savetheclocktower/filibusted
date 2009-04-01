class AddBillIdToVoteablesTables < ActiveRecord::Migration
  def self.up
    #rename_table :voteable, :voteables
    add_column :voteables, :bill_id, :integer
  end

  def self.down
    remove_column :voteables, :bill_id
    #rename_table :voteables, :voteable
  end
end
