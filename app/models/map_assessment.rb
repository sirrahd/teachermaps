class MapAssessment < ActiveRecord::Base
  attr_accessible :assessment_text, :rubric_text

  belongs_to :user
  belongs_to :map
  belongs_to :assessment, :class_name => 'Resource', :foreign_key => 'assessment_resource_id'
  belongs_to :rubric,     :class_name => 'Resource', :foreign_key => 'rubric_resource_id'
end
