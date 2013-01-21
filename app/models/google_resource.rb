class GoogleResource < Resource
	# attr_accessible :user_id, :resource_id
	belongs_to :user

	# Google File
  	attr_accessible :file_id

	def link 
  		# Depending on MIME TYPE return generated link

  	end 
end
