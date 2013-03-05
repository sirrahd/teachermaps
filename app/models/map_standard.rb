require 'uuidtools'
require 'base64'

class MapStandard < ActiveRecord::Base
  # Core components	
  attr_accessible :slug

  belongs_to :user
  belongs_to :map
  belongs_to :standard

  has_many :map_objectives

  validates :standard, :presence => {:message => 'cannot be blank.'}
  validates :user, :presence => {:message => 'cannot be blank.'}
  validates :map, :presence => {:message => 'cannot be blank.'}
  validates_uniqueness_of :slug, :allow_nil => true, :case_sensitive => true

  before_create :default_values

  private 

  def default_values
    self.slug ||= (Base64.strict_encode64 UUIDTools::UUID.random_create).downcase
  end

end
