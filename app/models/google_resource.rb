class GoogleResource < Resource
	# attr_accessible :user_id, :resource_id
	belongs_to :user

	# Google File
  	attr_accessible :file_id

	def open_link 
  		# Depending on MIME TYPE return generated link

  		return "https://docs.google.com/file/d/#{self.file_id}/edit"
  	end 
  	
end
