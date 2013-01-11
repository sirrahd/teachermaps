class Resource < ActiveRecord::Base
  attr_accessible :slug, :title, :url, :mime_type, :size


  belongs_to :resource_type

  belongs_to :user
    
  before_save do |resource|
    # Do some edits
  end
  
end



