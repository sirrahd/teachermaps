class LinkResource < Resource
	
	belongs_to :user

  	attr_accessible :link

  	validates :link, :presence => {:message => 'Link cannot be blank.'}, :length => {:minimum => 2, :maximum => 2048}
  	validates_format_of :link, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix
  	

  	def open_link()
		self.link
	end
end
