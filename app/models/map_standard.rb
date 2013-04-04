require 'uuidtools'
require 'base64'

class MapStandard < ActiveRecord::Base

  before_create :default_values
  # Core components	
  attr_accessible :slug

  belongs_to :user
  belongs_to :map
  belongs_to :standard

  has_many :map_objectives, dependent: :destroy

  validates :standard, presence: true
  validates :user, presence: true
  validates :map, presence: true
  validates_uniqueness_of :slug, allow_nil: true, case_sensitive: true

  before_destroy :before_deletion
  before_create :before_creation
  

  def owned_by?( user_id )
    self.user_id == user_id
  end
  
  private 


  def before_deletion
    Map.decrement_counter :standards_count, self.map.id
  end
  def before_creation
    if self.map.id
      Map.increment_counter :standards_count, self.map.id 
    end
  end

  def default_values
    self.slug ||= (Base64.strict_encode64 UUIDTools::UUID.random_create).downcase
  end

end
