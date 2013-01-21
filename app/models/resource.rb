class Resource < ActiveRecord::Base

	# TeacherMaps generated slug linking to a GoogleDrive/DropBox Resource 
	attr_accessible :slug

	# Common attributes shared accross each Cloud Services
	attr_accessible :file_size, :title, :mime_type

  	belongs_to :resource_type
  	belongs_to :user

  	# TeacherMaps specific attributes can be listed here

end



