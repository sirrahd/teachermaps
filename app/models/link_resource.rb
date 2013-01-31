class LinkResource < Resource
	
	belongs_to :user

  	attr_accessible :link

  	def open_link()
		self.link
	end
end
