class MapResource < ActiveRecord::Base
  attr_accessible :text

  belongs_to :user
  belongs_to :map
  belongs_to :resource

  validates :user, presence: true
  validates :resource, presence: true
  validates :map, presence: true
  validates :text, length: {maximum: 2048}

  before_validation	:clean_attrs

  before_destroy :before_deletion
  def before_deletion
    if self and self.map
      Map.decrement_counter :resources_count, self.map.id
    end
  end

  before_create :before_creation
  def before_creation
    if self and self.map
      Map.increment_counter :resources_count, self.map.id 
    end
  end

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

  before_create :default_values
  def default_values
    self.text = 'Description of the Resource'
  end
end
