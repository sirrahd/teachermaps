class AddResourceTypeToResource < ActiveRecord::Migration
  def up
    add_column :resources, :resource_type, :belongs_to
  end

  def down
  	remove_column :resources, :resource_type
  end
end
