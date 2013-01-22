class Resource < ActiveRecord::Base

	# TeacherMaps generated slug linking to a GoogleDrive/DropBox Resource 
	attr_accessible :slug

	# Common attributes shared accross each Cloud Services
	attr_accessible :file_size, :title, :mime_type

  	belongs_to :user

  	# TeacherMaps specific attributes can be listed here

  	before_save :default_values
  	def default_values
  		# Random, need to check for uniuqness
		self.slug ||= SecureRandom.urlsafe_base64
	end

end



