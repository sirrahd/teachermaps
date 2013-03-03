class MapStandard < ActiveRecord::Base
  # Core components	
  attr_accessible :name, :slug, :standard

  has_many :map_objectives

  belongs_to :user
  belongs_to :map

end
