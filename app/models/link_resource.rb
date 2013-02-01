class LinkResource < Resource
	
	belongs_to :user

  	attr_accessible :link

  	validates :link, :presence => {:message => 'Link cannot be blank.'}, :length => {:minimum => 2, :maximum => 2048}
  	

  	def open_link()
		self.link
	end
end
