class CreateMapAssessments < ActiveRecord::Migration
  def change
    create_table :map_assessments do |t|

      t.string :slug
      t.string :name
      t.text   :text, :limit => nil

      t.integer :user_id
      t.integer :map_id
      
      t.timestamps
    end
  end
end
