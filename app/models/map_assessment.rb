class MapAssessment < ActiveRecord::Base
  attr_accessible :slug, :name, :text

  belongs_to :user
  belongs_to :map

end
