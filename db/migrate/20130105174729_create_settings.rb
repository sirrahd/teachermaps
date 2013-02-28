class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
    	t.integer :user_id

      	t.string :upload_to
      
      	t.timestamps
    end
  end
end
