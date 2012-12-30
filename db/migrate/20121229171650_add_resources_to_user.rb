class AddResourcesToUser < ActiveRecord::Migration
  def change
    add_column :users, :resources, :has_many
  end
end
