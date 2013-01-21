class CreateGoogleResources < ActiveRecord::Migration
  def change
    create_table :google_resources do |t|


    	
    	t.string :type
      	t.timestamps
    end
  end
end
