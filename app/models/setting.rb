class Setting < ActiveRecord::Base
  
  attr_accessible :upload_to

  belongs_to :user
  
end
