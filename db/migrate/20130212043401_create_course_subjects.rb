class CreateCourseSubjects < ActiveRecord::Migration
  def change
    create_table :course_subjects do |t|

      t.timestamps
    end
  end
end
