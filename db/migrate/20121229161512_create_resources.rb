class CreateResources < ActiveRecord::Migration
  def up
  	create_table :resources do |t|
      t.string  :slug
      t.string  :title
      t.string  :url
      t.timestamps
    end

    add_column :users, :resources, :has_many
    add_column :resources, :user_id, :integer
    add_column :resources, :resource_type, :belongs_to
  end

  def down
  	drop_table :resources
  end
end
