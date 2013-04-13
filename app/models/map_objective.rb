require 'uuidtools'
require 'base64'


class MapObjective < ActiveRecord::Base
  attr_accessible :name, :slug, :text

  belongs_to :map_standard
  belongs_to :user
  belongs_to :map

  has_many :map_resources, :uniq => true, dependent: :destroy

  validates :map_standard, presence: true
  validates :user, presence: true
  validates :map, presence: true
  validates :name, length: {maximum: 250}
  validates :text, length: {maximum: 2048}
  validates_uniqueness_of :slug, allow_nil: true, case_sensitive: true

  before_create :default_values
  before_validation	:clean_attrs
  before_destroy :before_deletion
  before_create :before_creation

  def owned_by?( user )
    self.user_id == user.id
  end

  private 

  def before_deletion
    Map.decrement_counter :objectives_count, self.map.id
  end

  def before_creation
    if self.map.id
      Map.increment_counter :objectives_count, self.map.id 
    end
  end

  def clean_attrs
    default_values
    self.name = self.name.strip
    self.text = self.text.strip
  end

  def default_values
    self.slug ||= (Base64.strict_encode64 UUIDTools::UUID.random_create).downcase
    self.text = 'Description of the Map Objective'
    self.name = 'Untitled Map Objective'
  end
end
