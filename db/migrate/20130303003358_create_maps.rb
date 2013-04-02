# Itsa Meee!! Mario!!!!

class CreateMaps < ActiveRecord::Migration
  def self.up
    create_table :maps do |t|

      t.string :name
      t.string :slug
      t.text   :text
      t.text   :thumbnail

      t.integer :resources_count
      t.integer :objectives_count
      t.integer :standards_count

      t.integer :user_id

      t.timestamps
    end

    # Subjects
    create_table :course_subjects_maps, :id => false do |t|
      t.integer :course_subject_id
      t.integer :map_id
    end

    add_index :course_subjects_maps, [:course_subject_id,:map_id], :name => :course_subjects_maps_index
    add_index :course_subjects_maps, [:map_id,:course_subject_id], :name => :maps_course_subjects_index


    # Grades
    create_table :course_grades_maps, :id => false do |t|
      t.integer :course_grade_id
      t.integer :map_id
    end

    add_index :course_grades_maps, [:course_grade_id,:map_id], :name => :course_grades_maps_index
    add_index :course_grades_maps, [:map_id,:course_grade_id], :name => :maps_course_grades_index
  end



  def self.down
    remove_index :course_subjects_maps, :name => :course_subjects_maps_index
    remove_index :course_subjects_maps, :name => :maps_course_subjects_index
    drop_table :course_subjects_maps

    remove_index :course_grades_maps, :name => :course_grades_maps_index
    remove_index :course_grades_maps, :name => :maps_course_grades_index
    drop_table :course_grades_maps

    drop_table :maps
  end
end



