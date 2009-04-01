class AddVoteableTable < ActiveRecord::Migration
  def self.up
    create_table :voteable do |t|
      t.column :name, :string
      t.column :govtrack_id, :string
      
      t.column :type, :string
      
      t.timestamps
    end
  end

  def self.down
    drop_table :voteable    
  end
end
