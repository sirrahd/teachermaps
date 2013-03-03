class CreateMapAssessments < ActiveRecord::Migration
  def change
    create_table :map_assessments do |t|

      t.string :assessment_text
      t.string :rubric_text

      t.integer :user_id
      t.integer :map
      t.integer :assessment_resource_id
      t.integer :rubric_resource_id

      t.timestamps
    end
  end
end
