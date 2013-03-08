class Standard < ActiveRecord::Base

  # Searchable content, later will be indexed for Full Search Text
  attr_accessible :name, :text, :slug, :domain, :sub_subject

  belongs_to :course_subject
  belongs_to :standard_type

  # Parent/Child standard, points to self
  attr_accessible :is_parent_standard
  belongs_to :parent_standard, class_name: 'Standard', foreign_key: 'parent_standard_id'
  has_many :children_standards, class_name:'Standard', foreign_key: 'parent_standard_id'
  
  # Filterable via select options
  has_and_belongs_to_many :course_grades, :uniq => true, :order => 'name ASC'

  before_validation :clean_attrs

  validates :name, presence: true, length: {minimum: 2, maximum: 250}
  validates :text, presence: true, length: {minimum: 2, maximum: 2048}
  validates_uniqueness_of :slug, allow_nil: true, case_sensitive: true

  private 
  
  def clean_attrs
    if self.name then self.name = self.name.strip end
    if self.text then self.text = self.text.strip end
    if self.domain then self.domain = self.domain.strip end
    if self.sub_subject then self.sub_subject = self.sub_subject.strip end
  end

end
