class CreateStandardTypes < ActiveRecord::Migration
  def change
    create_table :standard_types do |t|
      t.string :name
    end
  end
end
