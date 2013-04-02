class CreateMapResources < ActiveRecord::Migration
  def change
    create_table :map_resources do |t|

      t.text    :text

      t.integer :resource_id
	    t.integer :user_id
      t.integer :map_id
      
      # MapObjectiveResource
      t.integer :map_objective_id
      # MapAssessmentResource
      t.integer :map_assessment_id

      t.string :type
      
      t.timestamps
    end
  end
end
