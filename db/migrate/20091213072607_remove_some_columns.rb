class RemoveSomeColumns < ActiveRecord::Migration
  def self.up
    remove_column :observations, :hi_temp
    remove_column :observations, :low_temp
    remove_column :observations, :updated_at
  end

  def self.down
    add_column :observations, :updated_at, :datetime
    add_column :observations, :low_temp, :float
    add_column :observations, :hi_temp, :float
  end
end
