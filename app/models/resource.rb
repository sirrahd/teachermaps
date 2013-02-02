class Resource < ActiveRecord::Base

	TYPE = 'Resource'

	# TeacherMaps generated slug linking to a GoogleDrive/DropBox Resource 
	attr_accessible :slug

	# Common attributes shared accross each Cloud Services
	attr_accessible :file_size, :title, :mime_type

  	belongs_to :user

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

end



