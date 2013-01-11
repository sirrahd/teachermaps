class CreateDropBoxAccounts < ActiveRecord::Migration
  def change
    create_table :drop_box_accounts do |t|

      t.timestamps
    end
  end
end
