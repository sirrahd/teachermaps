class AddAccountNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :account_name, :string
    add_index :users, :account_name, unique: true
  end
end