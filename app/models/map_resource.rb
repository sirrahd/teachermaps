class MapResource < ActiveRecord::Base
  attr_accessible :name

  belongs_to :user
  belongs_to :map
  belongs_to :resource
end
