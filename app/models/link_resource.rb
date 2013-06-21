class LinkResource < Resource

	TYPE = 'LinkResource'

  attr_accessible :title, :link
	
	belongs_to :user

  attr_accessible :link

  validates :link, :presence => { :message => I18n.t('link_resources.link_blank_error') }, :length => { :minimum => 2, :maximum => 2048 }
  validates_format_of :link, :with => /^(http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix, :message =>  I18n.t('link_resources.link_not_valid')
  	
  def open_link()
    if self.link.start_with? 'http'
		  self.link
    else
      "http://#{self.link}"
    end
	end

end
