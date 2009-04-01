class CreateBills < ActiveRecord::Migration
  def self.up
    create_table :bills do |t|
      t.column :name, :string
      t.column :govtrack_id, :string
      
      t.timestamps
    end
  end

  def self.down
    drop_table :bills
  end
end
