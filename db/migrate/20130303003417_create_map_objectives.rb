class CreateMapObjectives < ActiveRecord::Migration
  def change
    create_table :map_objectives do |t|

      t.string :name
      t.text   :text, :limit => nil
      t.string :slug

      t.integer :map_standard_id
      t.integer :user_id
      t.integer :map_id	

      t.timestamps
    end

    
  end

end
