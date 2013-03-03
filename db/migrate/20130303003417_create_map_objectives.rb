class CreateMapObjectives < ActiveRecord::Migration
  def change
    create_table :map_objectives do |t|

      t.timestamps
    end
  end
end
