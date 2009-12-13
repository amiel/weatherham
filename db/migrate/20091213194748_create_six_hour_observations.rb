class CreateSixHourObservations < ActiveRecord::Migration
  def self.up
    create_table :six_hour_observations do |t|
      t.datetime :observed_at
      t.float :temp
      t.integer :humidity
      t.float :dew_point
      t.float :wind_speed
      t.string :wind_dir
      t.float :wind_run
      t.float :hi_speed
      t.string :hi_dir
      t.float :wind_chill
      t.float :barometer
    end
  end

  def self.down
    drop_table :six_hour_observations
  end
end
