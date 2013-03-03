class CreateMapStandards < ActiveRecord::Migration
  def change
    create_table :map_standards do |t|

      t.timestamps
    end
  end
end
