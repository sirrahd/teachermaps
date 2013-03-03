class Map < ActiveRecord::Base
  # Core components	
  attr_accessible :name, :slug, :text, :thumbnail

  # For quick rendering of item counts
  attr_accessible :resources_count, :standards_count, :objectives_count

  has_many :course_subjects
  has_many :course_grades
  has_many :map_standards

  belongs_to :user
end