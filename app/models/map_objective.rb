require 'uuidtools'
require 'base64'


class MapObjective < ActiveRecord::Base
  attr_accessible :name, :slug, :text

  belongs_to :map_standard
  belongs_to :user
  belongs_to :map

  has_many :map_resources

  validates :map_standard, presence: true
  validates :user, presence: true
  validates :map, presence: true
  validates :name, length: {maximum: 250}
  validates :text, length: {maximum: 2048}
  validates_uniqueness_of :slug, allow_nil: true, case_sensitive: true

  before_create :default_values
  before_validation	:clean_attrs

  private 

  def clean_attrs
    if self.name then self.name = self.name.strip end
    if self.text then self.text = self.text.strip end
  end

  def default_values
    self.slug ||= (Base64.strict_encode64 UUIDTools::UUID.random_create).downcase
    self.text = 'Description of the Map Map Objective'
    self.name = 'Untitled Map Objective'
  end
end
