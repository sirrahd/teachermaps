class CreateStandards < ActiveRecord::Migration
  def change
    create_table :standards do |t|

      t.timestamps
    end
  end
end
