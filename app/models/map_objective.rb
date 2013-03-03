class MapObjective < ActiveRecord::Base
  attr_accessible :name, :slug

  belongs_to :user
  belongs_to :map

  has_many :map_resources
end
