class CreateFetches < ActiveRecord::Migration
  def change
    create_table :fetches do |t|
      t.datetime :start_at
      t.datetime :finish_at
      t.integer :observation_id
      t.boolean :error, default: false

      t.timestamps
    end
  end
end
