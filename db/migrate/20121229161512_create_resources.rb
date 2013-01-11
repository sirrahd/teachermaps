class CreateResources < ActiveRecord::Migration
  def up
  	create_table :resources do |t|
      t.string  :slug
      t.string  :title
      t.string  :url
      t.string  :mime_type
      t.decimal :size, :precision => 20, :scale => 2
      
      t.timestamps
    end

    add_column :resources, :user_id, :integer
  end

  def down
  	drop_table :resources
  end
end
