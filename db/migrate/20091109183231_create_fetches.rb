class CreateFetches < ActiveRecord::Migration
  def self.up
    create_table :fetches do |t|
      t.datetime :start_at
      t.datetime :finish_at
			t.integer :observation_id

      t.timestamps
    end
  end

  def self.down
    drop_table :fetches
  end
end
