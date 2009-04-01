class AddColumnsToVoteable < ActiveRecord::Migration
  def self.up
    add_column :voteables, :name, :string
    add_column :voteables, :govtrack_id, :string
    
    add_column :voteables, :type, :string
    
  end

  def self.down
    remove_column :voteables, :name
    remove_column :voteables, :govtrack_id
    
    remove_column :voteables, :type
  end
end
