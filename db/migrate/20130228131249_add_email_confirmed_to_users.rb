class AddEmailConfirmedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :confirmed, :integer, default: 0, null: false
  end
end
