class AddResources < ActiveRecord::Migration
  def up
  	create_table :resources do |t|
      t.string  :slug
      t.string  :title
      t.string  :url
      t.timestamps
    end
  end

  def down
  	drop_table :resources
  end
end
