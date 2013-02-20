class Resource < ActiveRecord::Base

	TYPE = 'Resource'
  MAX_TITLE_RENDER_LEN = 35
  
  
	# TeacherMaps generated slug linking to a GoogleDrive/DropBox Resource 
	attr_accessible :slug

	# Common attributes shared accross each Cloud Storage Services
	attr_accessible :file_size, :title, :mime_type, :file_upload

  	belongs_to :user
    belongs_to :resource_type

  	has_and_belongs_to_many :course_subjects, :uniq => true, :order => 'name ASC'
  	has_and_belongs_to_many :course_grades, :uniq => true, :order => 'id ASC'


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

  # def get_grades
  #   if self.course_grades.any?
      
  #     # Rails.logger.info("Grades: #{grades.inspect}")
  #     # grades.sort{|x,y| x.id <=> y.id }
  #     Rails.logger.info("Grades: #{grades.inspect}")
  #     # grades = self.course_grades.each { |grade| "#{grade.name}, " }
  #     self.course_grades
  #   end
  # end

  def get_type
    # return self.mime_type

    # if self.mime_type.nil?
    #   self.mime_type = MimeType.find_by_name('Web')
      
    #   Rails.logger.info("Type#{self.mime_type}")
    #   self.save()
    # end

    self.resource_type.name

    # if self.mime_type.nil?
    #   'Web'
    # else
    #   if MIME_TYPES.has_key?(self.mime_type)
    #     MIME_TYPES[self.mime_type]
    #   else
    #     Rails.logger.info("Could not locate MimeType: #{self.mime_type}")
    #     ''
    #   end
    # end
  end

end



