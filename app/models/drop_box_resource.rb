class DropBoxResource < Resource

	TYPE = 'DropBoxResource'
	
	attr_accessible :rev, :path, :link

	belongs_to :user

	def open_link()
		
		# safe_count = 0
		# while self.link.nil? && safe_count < 3
		# 	Rails.logger.info("Could not find link")
		# 	drop_box_account = DropBoxAccount.find_by_user_id( self.user_id )
		# 	self.link = drop_box_account.media_link( self.path )
		# 	# We do not want this to hang
		# 	safe_count += 1
		# end
		Rails.logger.info("Using link #{self.link}")
		self.link		
	end
end
