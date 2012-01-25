class AddRainToObservations < ActiveRecord::Migration
  def self.up
    add_column :observations, :rain, :float
    add_column :hourly_observations, :rain, :float
    add_column :six_hour_observations, :rain, :float
    add_column :daily_observations, :rain, :float
  end

  def self.down
    remove_column :daily_observations, :rain, :float
    remove_column :six_hour_observations, :rain, :float
    remove_column :hourly_observations, :rain, :float
    remove_column :observations, :rain
  end
end
