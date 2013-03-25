require 'uuidtools'
require 'base64'

class MapStandard < ActiveRecord::Base
  # Core components	
  attr_accessible :slug

  belongs_to :user
  belongs_to :map
  belongs_to :standard

  has_many :map_objectives

  validates :standard, presence: true
  validates :user, presence: true
  validates :map, presence: true
  validates_uniqueness_of :slug, allow_nil: true, case_sensitive: true
  #validates_uniqueness_of :teacher_id, :scope => [:semester_id, :class_id]
  validates_uniqueness_of :user_id, :scope => [:user_id, :standard_id, :user_id]

  before_create :default_values

  private 

  def default_values
    self.slug ||= (Base64.strict_encode64 UUIDTools::UUID.random_create).downcase
  end

end
