class AddGoogleToUser < ActiveRecord::Migration
  def up
    add_column :users, :google_api_id, :integer
  end

  def down
  	remove_column :users, :google_apis_id
  end
end
