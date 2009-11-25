class AddErrorToFetch < ActiveRecord::Migration
  def self.up
    add_column :fetches, :error, :boolean, :default => false
  end

  def self.down
    remove_column :fetches, :error
  end
end
