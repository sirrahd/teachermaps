class MapResource < ActiveRecord::Base
  attr_accessible :text

  belongs_to :user
  belongs_to :map
  belongs_to :map_objective
  belongs_to :resource

  validates :user, :presence => {:message => 'cannot be missing.'}
  validates :resource, :presence => {:message => 'cannot be missing.'}
  validates :map, :presence => {:message => 'cannot be missing.'}
  validates :map_objective, :presence => {:message => 'cannot be missing.'}
  validates :text, :presence => {:message => 'cannot be blank.'}, :length => {:minimum => 2, :maximum => 2048}

  before_validation	:clean_attrs

  private 

  def clean_attrs
    if self.text then self.text = self.text.strip end
  end
end
