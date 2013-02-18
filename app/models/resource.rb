class Resource < ActiveRecord::Base

	TYPE = 'Resource'
  MAX_TITLE_RENDER_LEN = 35
  
	# TeacherMaps generated slug linking to a GoogleDrive/DropBox Resource 
	attr_accessible :slug

	# Common attributes shared accross each Cloud Services
	attr_accessible :file_size, :title, :mime_type, :file_upload



  	belongs_to :user

  	has_and_belongs_to_many :course_subjects, :uniq => true
  	has_and_belongs_to_many :course_grades, :uniq => true

  	# accepts_nested_attributes_for :course_subjects
  	# accepts_nested_attributes_for :course_grades

  	attr_accessible :course_subjects
  	attr_accessible :course_grades

  	# TeacherMaps specific attributes can be listed here
  	validates :title, :presence => {:message => I18n.t('resources.title_blank_error')}, :length => {:minimum => 2, :maximum => 2048}

  	before_create :default_values
  	def default_values
  		# Random, need to check for uniuqness
		self.slug ||= SecureRandom.urlsafe_base64.downcase
	end

	def to_param
		self.slug
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

end



