# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_name    :string(255)
#  password_digest :string(255)
#  remember_token  :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :account_name, :password, :password_confirmation
  has_secure_password

  has_one :google_account
  has_one :drop_box_account
  has_one :setting
  #has_many :resources, order: 'title ASC, updated_at DESC'
  has_many :resources, order: 'updated_at DESC'
  has_many :maps, order: 'id DESC'

  before_save do |user|
    user.email = user.email.downcase
    user.account_name = user.account_name.downcase
  end

  before_save :create_remember_token
  before_create :default_values

  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    length: { maximum: 50 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  VALID_ACCOUNT_NAME_REGEX = /\A[a-z]+\w*\z/i
  validates :account_name, presence: true,
                    length: { minimum: 5, maximum: 20 },
                    format: { with: VALID_ACCOUNT_NAME_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6 }, confirmation: true, if: :password_digest_changed?

  def has_google_account?
    !google_account.nil? and !google_account.folder_id.nil?
  end

  def has_drop_box_account?
    !drop_box_account.nil? and !drop_box_account.session_token.nil?
  end

  def to_param
    self.account_name
  end

  def request_key
    Digest::MD5.hexdigest(self.email + self.account_name + self.confirmed.to_s + self.password_digest + self.created_at.iso8601)
  end

  def total_resources_count
    Resource.where( user_id: self.id ).count
  end

  def is_admin?( user )
  	# Admin permission gives a user the abiilty to edit an entity

  	# Check to see is user's id matches candidate user's id 
  	# Else check to see if map is public
  	Rails.logger.info "Permissions check: #{self.id}:#{user.id} #{self.id == user.id}"
		self.id == user.id # and self.is_public?
    
    # Later we can add collaborator/group permission checks in this method
  end

  def public_maps
  	self.maps.where("privacy_state = #{PrivacyState::PUBLIC}")
  end

  private

  def default_values
    self.setting = Setting.new
  end

  def create_remember_token
    self.remember_token ||= SecureRandom.urlsafe_base64
  end
end
