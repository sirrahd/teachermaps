class Standard < ActiveRecord::Base

  # Searchable content, later will be indexed for Full Search Text
  attr_accessible :name, :text, :slug, :domain, :sub_subject

  # Parent/Child standard
  #belongs_to :parent_standard, :class_name => 'Standard', :foreign_key => ''
  has_many :children_standards, :class_name => 'Standard', :foreign_key => 'parent_standard_id'
  belongs_to :parent_standard, :class_name => 'Standard', :foreign_key => 'parent_standard_id'
  # belongs_to :parent_standard
  attr_accessible :is_parent_standard

  
  # Filterable via select options
  has_and_belongs_to_many :course_grades, :uniq => true, :order => 'name ASC'

  belongs_to :course_subject
  belongs_to :standard_type

end
