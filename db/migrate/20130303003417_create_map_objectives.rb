class CreateMapObjectives < ActiveRecord::Migration
  def change
    create_table :map_objectives do |t|

      t.string :name
      t.text   :text
      t.string :slug

      t.integer :map_standard_id
      t.integer :user_id
      t.integer :map_id	

      t.timestamps
    end

    change_column :map_objectives, :text, :text, :limit => nil

    
  end

end
