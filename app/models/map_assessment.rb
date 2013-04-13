require 'uuidtools'
require 'base64'

class MapAssessment < ActiveRecord::Base

  after_initialize :default_values
  before_validation :clean_attrs

  attr_accessible :name, :text, :map_id, :user_id

  belongs_to :user
  belongs_to :map

  has_many :map_resources, :uniq => true, dependent: :destroy

  validates :map, presence: true
  validates :user, presence: true
  validates :name, length: {minimum: 2, maximum: 250}
  validates :text, length: {minimum: 2, maximum: 2048}
  validates_uniqueness_of :slug, case_sensitive: true

  def owned_by?( user )
    self.user_id == user.id
  end

  private 

  def clean_attrs
    default_values
    self.name = self.name.strip
    self.text = self.text.strip
  end

  def default_values
    self.slug ||= (Base64.strict_encode64 UUIDTools::UUID.random_create).downcase
    self.name ||= 'Untitled Map Assessment'
    self.text ||= 'Description of the Map Assessment'
  end

end
