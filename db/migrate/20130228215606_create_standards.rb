class CreateStandards < ActiveRecord::Migration
  def self.up
    create_table :standards do |t|

      # These later are going to be indexed using Solr/Lucene
      t.string :name				# Title
      t.string :text				# Description/content
      t.string :domain 			# Domain 
      t.string :sub_subject	# Indexable string sub subject Science => "Life Science"
      t.string :slug				# A unique identifier of standard

      # t.integer :course_grade_id
      t.integer :course_subject_id
      t.integer :standard_type_id

      # If parent ID is selected, we select all children
      t.integer :parent_standard_id
      t.boolean :is_parent_standard

    end

    # Grades
    create_table :course_grades_standards, :id => false do |t|
      t.integer :course_grade_id
      t.integer :standard_id
    end

    add_index :course_grades_standards, [:course_grade_id,:standard_id], :name => :course_grades_standards_index
    add_index :course_grades_standards, [:standard_id,:course_grade_id], :name => :standards_course_grades_index

  end

  def self.down
    remove_index :course_grades_standards, :name => :course_grades_standards_index
    remove_index :course_grades_standards, :name => :standards_course_grades_index
    drop_table :course_grades_standards

    drop_table :standards
  end

end
