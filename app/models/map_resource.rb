class MapResource < ActiveRecord::Base
  attr_accessible :text

  belongs_to :user
  belongs_to :map
  belongs_to :resource

  validates :user, presence: true
  validates :resource, presence: true
  validates :map, presence: true
  validates :text, length: {minimum: 2, maximum: 2048}

  before_destroy :before_deletion
  before_create :before_creation
  before_validation	:clean_attrs
  after_initialize :default_values

  def owned_by?( user )
    self.user_id == user.id
  end

  private 

  def before_deletion
    if self and self.map
      Map.decrement_counter :resources_count, self.map.id
    end
  end
  
  def before_creation
    if self and self.map
      Map.increment_counter :resources_count, self.map.id 
    end
  end

  def clean_attrs
    default_values
    self.text = self.text.strip
  end

  def default_values
    self.text ||= 'Description of the Resource'
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
