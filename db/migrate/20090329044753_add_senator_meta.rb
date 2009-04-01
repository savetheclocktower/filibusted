class AddSenatorMeta < ActiveRecord::Migration
  def self.up
    add_column :senators, :meta, :text
  end

  def self.down
    remove_column :senators, :meta
  end
end
