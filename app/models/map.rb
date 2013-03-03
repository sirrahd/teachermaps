class Map < ActiveRecord::Base
  # Core components	
  attr_accessible :name, :slug, :text, :thumbnail

  # For quick rendering of item counts
  attr_accessible :resources_count, :standards_count, :objectives_count

  has_and_belongs_to_many :course_subjects, :uniq => true, :order => 'name ASC'
  has_and_belongs_to_many :course_grades, :uniq => true, :order => 'id ASC'
  has_many :map_standards

  belongs_to :user

  validates :name, :presence => {:message => 'cannot be blank.'}, :length => {:minimum => 2, :maximum => 250}

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
  	# Random, need to check for uniuqness
	self.slug ||= SecureRandom.urlsafe_base64.downcase
  end
end

