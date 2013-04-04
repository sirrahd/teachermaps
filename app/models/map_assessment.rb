require 'uuidtools'
require 'base64'

class MapAssessment < ActiveRecord::Base
  before_create :default_values
  before_validation :clean_attrs

  attr_accessible :name, :text, :map_id

  belongs_to :user
  belongs_to :map

  has_many :map_resources, :uniq => true, dependent: :destroy

  validates :map, presence: true
  validates :user, presence: true
  validates :name, length: {maximum: 250}
  validates :text, length: {maximum: 2048}
  validates_uniqueness_of :slug, allow_nil: true, case_sensitive: true

  private 

  def clean_attrs
    if self.name then self.name = self.name.strip end
    if self.text then self.text = self.text.strip end
  end

  def default_values
    self.slug ||= (Base64.strict_encode64 UUIDTools::UUID.random_create).downcase
    self.name = 'Untitled Map Assessment'
    self.text = 'Description of the Assessment'
  end

end
