class CreateMapObjectives < ActiveRecord::Migration
  def change
    create_table :map_objectives do |t|

      t.string :name
      t.string :slug

      t.integer :user_id
      t.integer :map_id	

      t.timestamps
    end

    
  end

end
