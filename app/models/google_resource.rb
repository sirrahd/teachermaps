class GoogleResource < Resource
	# attr_accessible :user_id, :resource_id
	belongs_to :user

	# Google File
  	attr_accessible :file_id

	def open_link 

		Rails.logger.info("File: #{self.title} : #{self.mime_type}")
  		# Depending on MIME TYPE return generated link
  		link = ''
  		
  		if self.mime_type == 'application/vnd.google-apps.folder'
  			link = "https://drive.google.com/#folders/#{self.file_id}"
  		
  		elsif self.mime_type == 'application/vnd.google-apps.drawing'
  			link = "https://docs.google.com/drawings/d/#{self.file_id}/edit"

  		elsif self.mime_type == 'application/vnd.google-apps.presentation'
  			link = "https://docs.google.com/presentation/d/#{self.file_id}/edit"

  		elsif self.mime_type == 'application/vnd.google-apps.spreadsheet'
  			link = "https://docs.google.com/spreadsheet/ccc?key=#{self.file_id}"

  		elsif self.mime_type == 'application/vnd.google-apps.document'
  			link = "https://docs.google.com/document/d/#{self.file_id}/edit"
  		
  		else # Default 
  			link = "https://docs.google.com/file/d/#{self.file_id}/edit"
  		end

  		return link
	end 

end
