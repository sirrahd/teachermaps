class AddCourseGradeToResources < ActiveRecord::Migration
  def self.up
    create_table :resources_grades, :id => false do |t|
	  t.references  :course_grade,:resource
	end

	add_index :resources_grades, [:course_grade_id,:resource_id,]
  end

  def self.down
    drop_table :resources_grades
  end
end
