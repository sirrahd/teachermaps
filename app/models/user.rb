# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  alias      :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :alias, :password, :password_confirmation
  # Not sure if we need to store password_confirmation
  has_many :resources

  has_secure_password
  
  before_save do |user|
    user.email = user.email.downcase
    user.alias = user.alias.downcase
  end

  # Does this create new cookie every save call?
  before_save :create_remember_token
  
  validates :name, presence: true, length: { maximum: 50 }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    length: { maximum: 50 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  
  VALID_ALIAS_REGEX = /\A[a-z]+\w*\z/i
  validates :alias, presence: true,
                    length: { minimum: 5, maximum: 20 },
                    format: { with: VALID_ALIAS_REGEX },
                    uniqueness: { case_sensitive: false }
  
  validates :password, presence: true,  length: { minimum: 6 }
  validates :password_confirmation, presence: true


  def has_google_account?
    !self.google_api_id.nil?
    

  def friendly_link
    # Should we cache or DB this? 
    # No need to store in db if it is repeat of alias
    Rails.application.routes.url_helpers.users_path + '/' + self.alias
  end 

  private
  
  def create_remember_token
    #self.remember_token = SecureRandom.urlsafe_base64
    # Possibly more secure/random
    seed = "--#{rand(10000)}--#{Time.now}--"
    self.remember_token = Digest::SHA1.hexdigest(seed)
  end
end
