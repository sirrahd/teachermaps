class MapAssessment < ActiveRecord::Base
  attr_accessible :slug, :name, :text

  belongs_to :user
  belongs_to :map

  validates :map, presence: true
  validates :user, presence: true
  validates :name, presence: true, length: {minimum: 2, maximum: 250}
  validates :text, presence: true, length: {minimum: 2, maximum: 2048}
  validates_uniqueness_of :slug, allow_nil: true, case_sensitive: true

  before_create :default_values
  before_validation	:clean_attrs

  private 

  def clean_attrs
    if self.name then self.name = self.name.strip end
    if self.text then self.text = self.text.strip end
  end

  def default_values
    self.slug ||= (Base64.strict_encode64 UUIDTools::UUID.random_create).downcase
  end

end
