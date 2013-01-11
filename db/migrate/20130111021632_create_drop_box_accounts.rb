class CreateDropBoxAccounts < ActiveRecord::Migration
  def change
    create_table :drop_box_accounts do |t|
      t.integer :user_id
      
      t.timestamps
    end
  end
end
