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
  validates :name, length: {minimum: 1, maximum: 250}
  validates :text, length: {minimum: 1, maximum: 2048}
  validates_uniqueness_of :slug, allow_nil: true, case_sensitive: true

  def owned_by?( user )
    self.user_id == user.id
  end

  private 

  def clean_attrs
    # self.name ||= 'Untitled Map Assessment'
    # self.text ||= 'Description of the Assessment'
    if self.name then self.name = self.name.strip end
    if self.text then self.text = self.text.strip end
  end

  def default_values
    self.slug ||= (Base64.strict_encode64 UUIDTools::UUID.random_create).downcase
    self.name ||= 'Untitled Map Assessment'
    self.text ||= 'Description of the Assessment'
  end

end
