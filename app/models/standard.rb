class Standard < ActiveRecord::Base

  # Searchable content, later will be indexed for Full Search Text
  attr_accessible :name, :text, :domain, :sub_subject

  # Parent/Child standard
  belongs_to :parent_standard, :class_name 'Standard', :foreign_key => 'parent_standard_id'
  attr_accessible :is_parent_standard

  # Filterable via select options
  belongs_to :course_grade
  belongs_to :course_subject
  belongs_to :standard_type

end
