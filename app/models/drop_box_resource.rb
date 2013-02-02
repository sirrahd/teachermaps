class DropBoxResource < Resource

	TYPE = 'DropBoxResource'
	
	attr_accessible :rev, :path, :link

	belongs_to :user

	#TODO: Refactor this to be called when crated and cache in db
	def open_link()
		self.link
		# drop_box_account = DropBoxAccount.find_by_user_id( self.user_id )
		# link = drop_box_account.media_link( self.path )
		# link
		
	end
end
