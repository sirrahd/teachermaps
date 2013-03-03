class CreateMapAssessments < ActiveRecord::Migration
  def change
    create_table :map_assessments do |t|

      t.timestamps
    end
  end
end
