class MapObjective < ActiveRecord::Base
  attr_accessible :name, :slug

  belongs_to :map_standard
  belongs_to :user
  belongs_to :map

  has_many :map_resources

  validates :name, :presence => {:message => 'cannot be blank.'}, :length => {:minimum => 2, :maximum => 250}
  validates :map_standard, :presence => {:message => 'cannot be blank.'}
  validates :user, :presence => {:message => 'cannot be blank.'}
  validates :map, :presence => {:message => 'cannot be blank.'}
  validates_uniqueness_of :slug, :allow_nil => true, :case_sensitive => true

  before_create :default_values
  before_validation	:clean_attrs
  
  private 

  def clean_attrs
    if self.name then self.name = self.name.strip end
  end

  def default_values
    self.slug ||= (Base64.strict_encode64 UUIDTools::UUID.random_create).downcase
  end
end
