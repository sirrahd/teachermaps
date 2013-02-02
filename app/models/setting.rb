class Setting < ActiveRecord::Base
  
  attr_accessible :upload_to

  belongs_to :user


  def has_upload_to?
  	return !self.upload_to.nil?
  end
  
end
