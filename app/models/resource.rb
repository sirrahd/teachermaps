class Resource < ActiveRecord::Base

	TYPE = 'Resource'
  MAX_TITLE_RENDER_LEN = 35
  
  
	# TeacherMaps generated slug linking to a GoogleDrive/DropBox Resource 
	attr_accessible :slug

	# Common attributes shared accross each Cloud Storage Services
	attr_accessible :file_size, :title, :mime_type

  belongs_to :user
  belongs_to :resource_type

  has_and_belongs_to_many :course_subjects, uniq: true, order: 'name ASC'
  has_and_belongs_to_many :course_grades, uniq: true, order: 'id ASC'


  # TeacherMaps specific attributes can be listed here
  validates :title, presence: {:message => I18n.t('resources.title_blank_error')}, length: {minimum: 2, maximum: 250}

  before_create :default_values
  def default_values
  	# Random, need to check for uniuqness
		self.slug ||= SecureRandom.urlsafe_base64.downcase
	end

	def to_param
		self.slug
	end

  def assign_type
      conversion_table = ResourceType::MIME_TYPE_CONVERSIONS

      if self.mime_type.nil?
        # Web content
        self.resource_type = ResourceType.find_by_name 'Web'
      else
        if conversion_table.has_key?(self.mime_type)
          # If we have a mapping conversion
          self.resource_type = ResourceType.find_by_name conversion_table[self.mime_type]
        else
          # If we do not have a mapping conversion
          self.resource_type = ResourceType.find_by_name 'Other'
        end
      end
      self.save
  end



  def self.inherited(child)
    # http://www.alexreisner.com/code/single-table-inheritance-in-rails
    # Needed so we can use a single form for all Resource types
    child.instance_eval do
      def model_name
        Resource.model_name
      end
    end
    super
  end

  def get_thumbnail
    "<div class='#{self.resource_type.thumbnail}'></div>"
  end

  def get_type
    self.resource_type.name
  end

end



