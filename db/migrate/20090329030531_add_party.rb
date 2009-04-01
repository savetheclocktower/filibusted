class AddParty < ActiveRecord::Migration
  def self.up
    add_column :senators, :party, :string
  end

  def self.down
    remove_column :senators, :party
  end
end
