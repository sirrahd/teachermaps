class GoogleResource < Resource
	# attr_accessible :user_id, :resource_id
	belongs_to :user

	# Google File
  	attr_accessible :file_id

	def open_link 
  		# Depending on MIME TYPE return generated link

  		return 'http://www.google.com'
  	end 

  	def download_link

  		return 'http://www.google.com'
  	end
end
