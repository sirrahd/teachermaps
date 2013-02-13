class AddCourseGradeToResources < ActiveRecord::Migration
  def self.up
    create_table :course_grades_resources, :id => false do |t|
      t.integer :course_grade_id
      t.integer :resource_id
	end

	add_index :course_grades_resources, [:course_grade_id,:resource_id,], :name => 'course_grades_resources_index'
	add_index :course_grades_resources, [:resource_id,:course_grade_id], :name => 'resources_course_grades_index'
  end

  def self.down
    drop_table :course_grades_resources
  end
end
