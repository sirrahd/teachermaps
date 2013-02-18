class Resource < ActiveRecord::Base

	TYPE = 'Resource'
  MAX_TITLE_RENDER_LEN = 35
  MIME_TYPES = {
    'text/html' => 'HTML',
    'text/plain'=> 'Text',
    'application/rtf'=> 'Text',
    'application/vnd.oasis.opendocument.text'=> 'Word Document',
    'application/pdf'=> 'PDF',
    'application/msword' => 'Word Document',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document' => 'Word Document',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' => 'Spreadsheet',
    'application/x-vnd.oasis.opendocument.spreadsheet' => 'Spreadsheet',
    'image/jpeg'=> 'Image',
    'image/gif'=> 'Image',
    'image/png'=> 'Image',
    'image/svg+xml'=> 'Image',
    'application/vnd.openxmlformats-officedocument.presentationml.presentation' => 'Presentation'
  }
  
	# TeacherMaps generated slug linking to a GoogleDrive/DropBox Resource 
	attr_accessible :slug

	# Common attributes shared accross each Cloud Services
	attr_accessible :file_size, :title, :mime_type, :file_upload



  	belongs_to :user

  	has_and_belongs_to_many :course_subjects, :uniq => true
  	has_and_belongs_to_many :course_grades, :uniq => true, :order => 'id ASC'


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

    if self.mime_type.nil?
      'Web'
    else
      if MIME_TYPES.has_key?(self.mime_type)
        MIME_TYPES[self.mime_type]
      else
        Rails.logger.info("Could not locate MimeType: #{self.mime_type}")
        ''
      end
    end
  end

end



