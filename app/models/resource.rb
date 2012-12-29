class Resource < ActiveRecord::Base
  attr_accessible :slug, :title, :url


  belongs_to :resource_type
  # has_one or belongs_to??

  # belongs_to :user
    
  before_save do |resource|
    # Do some edits
  end
  
end



