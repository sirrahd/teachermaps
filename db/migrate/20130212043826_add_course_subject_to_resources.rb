class AddCourseSubjectToResources < ActiveRecord::Migration
  def self.up
    create_table :resources_subjects, :id => false do |t|
	  t.references :course_subject, :resource 
	end

	add_index :resources_subjects, [:course_subject_id,:resource_id]
  end

  def self.down
    drop_table :resources_subjects
  end
end
