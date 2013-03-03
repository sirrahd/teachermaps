class CreateMapStandards < ActiveRecord::Migration
  def change
    create_table :map_standards do |t|

      t.string :name
      t.string :slug

      t.integer :standard_id
      t.integer :map_id
      t.integer :user_id

      t.timestamps
    end
  end
end
