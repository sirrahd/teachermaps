class CreateMapResources < ActiveRecord::Migration
  def change
    create_table :map_resources do |t|

      t.timestamps
    end
  end
end
