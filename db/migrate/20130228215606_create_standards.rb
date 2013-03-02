class CreateStandards < ActiveRecord::Migration
  def change
    create_table :standards do |t|

      # These later are going to be indexed using Solr/Lucene
      t.string :name				# Title
      t.string :text				# Description/content
      t.string :domain 				# Domain 
      t.string :sub_subject		 	# Indexable string sub subject Science => "Life Science"
      t.string :slug				# A unique identifier of standard

      t.integer :course_grade_id
      t.integer :course_subject_id
      t.integer :standard_type_id

      # If parent ID is selected, we select all children
      t.integer :parent_standard_id
      t.boolean :is_parent_standard

    end
  end
end
