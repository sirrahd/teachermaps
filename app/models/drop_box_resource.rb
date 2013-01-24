class DropBoxResource < Resource
	
	attr_accessible :rev, :path

	belongs_to :user

	def open_link()
		drop_box_account = DropBoxAccount.find_by_user_id( self.user_id )
		link = drop_box_account.media_link( self.path )
		link
		
	end
end
