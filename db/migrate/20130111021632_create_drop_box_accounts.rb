class CreateDropBoxAccounts < ActiveRecord::Migration
  def change
    create_table :drop_box_accounts do |t|
      t.integer :user_id
      t.string  :session_token
      t.string  :file_hash
      t.string  :cursor
      
      t.timestamps
    end
  end
end
