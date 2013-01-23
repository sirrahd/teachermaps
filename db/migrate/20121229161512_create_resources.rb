class CreateResources < ActiveRecord::Migration
  def up
  	create_table :resources do |t|
      t.string  :slug
      t.string  :title
      t.string  :mime_type
      t.string  :file_size

      # in bytes
      t.string :size

      # Google Drive
      t.string :file_id

      # DropBox
      t.string :rev 
      t.string :path 

      t.string :type
      t.timestamps
    end

    add_column :resources, :user_id, :integer
  end

  def down
  	drop_table :resources
  end
end
