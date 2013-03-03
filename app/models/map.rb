require 'uuidtools'
require 'base64'

class Map < ActiveRecord::Base
  # Core components	
  attr_accessible :name, :slug, :text, :thumbnail

  # For quick rendering of item counts
  attr_accessible :resources_count, :standards_count, :objectives_count

  has_and_belongs_to_many :course_subjects, :uniq => true, :order => 'name ASC'
  has_and_belongs_to_many :course_grades, :uniq => true, :order => 'id ASC'
  has_many :map_standards

  belongs_to :user

  validates :user, :presence => {:message => 'cannot be blank.'}
  validates :name, :presence => {:message => 'cannot be blank.'}, :length => {:minimum => 2, :maximum => 250}
  validates :text, :presence => {:message => 'cannot be blank.'}, :length => {:minimum => 2, :maximum => 2048}
  validates_uniqueness_of :slug, :allow_nil => true, :case_sensitive => true

  before_create :default_values
  before_validation	:clean_attrs

  def to_param
	  self.slug
  end

  private 

  def clean_attrs
    if self.name then self.name = self.name.strip end
    if self.text then self.text = self.text.strip end
  end

  def default_values
    self.slug ||= (Base64.strict_encode64 UUIDTools::UUID.random_create).downcase
  
    self.resources_count  ||= 0
    self.standards_count  ||= 0
    self.objectives_count ||= 0
  end
  
end

