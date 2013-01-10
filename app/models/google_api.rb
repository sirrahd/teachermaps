


class GoogleApi < ActiveRecord::Base
  attr_accessible :user_id, :folder_id, :access_token, :refresh_token, :expires_in, :issued_at
  
end
