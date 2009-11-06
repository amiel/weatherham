class CreateObservations < ActiveRecord::Migration
  def self.up
    create_table :observations do |t|
      t.datetime :observed_at
      t.float :temp
      t.float :hi_temp
      t.float :low_temp
      t.integer :humidity
      t.float :dew_point
      t.float :wind_speed
      t.string :wind_dir
      t.float :wind_run
      t.float :hi_speed
      t.string :hi_dir
      t.float :wind_chill
      t.float :barometer

      t.timestamps
    end
  end

  def self.down
    drop_table :observations
  end
end
