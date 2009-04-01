class PromoteStateAndInOffice < ActiveRecord::Migration
  def self.up
    add_column :senators, :state, :string
    add_column :senators, :in_office, :boolean
  end

  def self.down
    remove_column :senators, :state
    remove_column :senators, :in_office
  end
end
