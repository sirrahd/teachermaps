class AddAliasToUsers < ActiveRecord::Migration
  def change
    add_column :users, :alias, :string
    User.all.each do |user|
      user.update_attributes!(alias: user.id)
    end
    add_index :users, :alias, unique: true
  end
end
