class ResourceType < ActiveRecord::Base
  attr_accessible :name

  validates :name, presence: true, length: { maximum: 100 }
end
