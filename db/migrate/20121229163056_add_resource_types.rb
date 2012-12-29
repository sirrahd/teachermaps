class AddResourceTypes < ActiveRecord::Migration

  def up
  	create_table :resource_types do |t|
      t.string :name
    end
  end

  def down
  	drop_table :resource_types
  end

end
