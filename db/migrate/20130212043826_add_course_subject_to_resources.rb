class AddCourseSubjectToResources < ActiveRecord::Migration
  def self.up
    create_table :course_subjects_resources, :id => false do |t|
	  t.integer :course_subject_id
      t.integer :resource_id
	end

	add_index :course_subjects_resources, [:course_subject_id,:resource_id], :name => 'course_subjects_resources_index'
	add_index :course_subjects_resources, [:resource_id,:course_subject_id], :name => 'resources_course_subjects_index'
  end

  def self.down
    drop_table :course_subjects_resources
  end
end
