class CreateCourseGrades < ActiveRecord::Migration
  def change
    create_table :course_grades do |t|

      t.timestamps
    end
  end
end
