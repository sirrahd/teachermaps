class MapResource < ActiveRecord::Base
  attr_accessible :text

  belongs_to :user
  belongs_to :map
  belongs_to :resource

  validates :user, :presence => {:message => 'cannot be missing.'}
  validates :resource, :presence => {:message => 'cannot be missing.'}
  validates :map, :presence => {:message => 'cannot be missing.'}
  validates :text, :presence => {:message => 'cannot be blank.'}, :length => {:minimum => 2, :maximum => 2048}

  before_validation	:clean_attrs

  private 

  def clean_attrs
    if self.text then self.text = self.text.strip end
  end

  def self.inherited(child)
    # http://www.alexreisner.com/code/single-table-inheritance-in-rails
    # Needed so we can use a single form for all Resource types
    child.instance_eval do
      def model_name
        MapResource.model_name
      end
    end
    super
  end
end
