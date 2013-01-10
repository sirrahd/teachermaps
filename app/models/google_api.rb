


class GoogleApi < ActiveRecord::Base
  attr_accessible :access_token, :refresh_token, :expires_in, :issued_at, :folder_id

  belongs_to :user

end
