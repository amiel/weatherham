class AddRainToObservations < ActiveRecord::Migration
  def self.up
    add_column :observations, :rain, :float
  end

  def self.down
    remove_column :observations, :rain
  end
end
