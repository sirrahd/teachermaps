class CreateStandardTypes < ActiveRecord::Migration
  def change
    create_table :standard_types do |t|

      t.timestamps
    end
  end
end
