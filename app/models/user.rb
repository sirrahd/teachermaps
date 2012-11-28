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
  has_secure_password
  
  before_save do |user|
    user.email = user.email.downcase
    user.alias = user.alias.downcase
  end
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
  
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def friendly_link
    Rails.application.routes.url_helpers.users_path + '/' + self.alias
  end # Should we cache or DB this?

  private
  
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
