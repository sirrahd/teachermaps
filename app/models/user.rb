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




# MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
# MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
# MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
# MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM8NII?=7MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
# MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM8==++++++=+II?DMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
# MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+?7?II7+++++~$?MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
# MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMII7MMMMZ???????I7I??I??7NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
# MMMMMMMMMMMMMMMMMMMMMMMMMMMN8Z?IZMMMMMM+??????????7?????+OMMMMMMMMMMMMMMMMM$INMMMMMMMMMMMMMMMMMMMMMM
# MMMMMMMMMMMMMMMMMMMMN++???????INMMMMMMMN+??????????I??M8I??=NMMMMMMMMMMMMMMM?IMMMMMMMMMMMMMMMMMMMMMM
# MMMMMMMMMMMMMMMMMMM$?II7Z8ZZOIIMMMMMMMMMM?=+??????????DMMM8$NMMMMMMMMMMMMMMM$?ZNMMMMMMMMMMMMMMMMMMMM
# MMMMMMMMMMMMMMMMDIIOZIIIIIIZOZIDMMMMMMMMMMMMMM7I??????IDMMMMMMMMMMMMMMMMMMMMD$IIINMMMMMMMMMMMMMMMMMM
# MMMMMMMMMMMMMM8?OZIIIIIIIIIZZ$$IMMMMMMMMMMMMMMMM?I?????MMMMMMMMMMMMMMMMMMMMMIIOZO7I7DMMMMMMMMMMMMMMM
# MMMMMMMMMMMZ?IO7IIIIIIIIII7ZZIOI$MMMMMMMMMMMMMMMI+?????ZMMMMMMMMMMMMMMMMMMMOOZOZZZZ7IZMMMMMMMMMMMMMM
# MMMMMMMMMMDIO7IIIIIIIIIIII$Z$II7?MMMMMMMMMMMMMMMD=??????MMMMMMMMMMMMMMMMMMDOZZZZZZZI$I8MMMMMMMMMMMMM
# MMMMMMMMMM?O$IIIIIIIIIIIII$ZIIIOI$MMMMMMMMMMMMMMM?+?????MMMMMMMMMMMMMMMMMOIZZZZZZ$$IIII7MMMMMMMMMMMM
# MMMMMMMMMZ77IIIIIIIIIIIIII$Z7I77$?8MMMMMMMMMMMMMM7+?????$MMMMMMMMMMMMMMMM7ZZ$ZZZZZIIIIIOIOMMMMMMMMMM
# MMMMMMMMZI$IIIIIIIIIIIIIIIZI$IIIZI?ZMMMMMMMMMMMMM$++?????NMMMMMMMMMMMMMD?OZZ7$ZZZZIIIIIIIOIZNMMMMMMM
# MMMMMMMDIOIIIIIIIIIIIIIIII$I7III7$OZI?ZMMMMMMMMMMO+++????OMMMMMMMMMMMMM?OZZIIIZZZZ7IIIIIII$ZINMMMMNZ
# MMMMMMZ?O7IIIIII$ZZZIIIIIIIZ7I777I7ZOZOZ?8MMMMMMMO++++???IMMMMMMMMMMD7I$ZZ$IIIZZZZ$IIIIIIIIIZ7MMMMO?
# MMMMMM?8$77I7DMMMMMMM8IIIIIZI77I777$OOOZZZIIDMMMMZ++++????MMMMMMMOII7OOZZZIIIIZZZZZIIIIIIIIII$8MMMOI
# MMMMMZZZ$7$MMMMMMMMMMMM$IIZZ7777777$ZOZOOZO87II7M?+=+++???8MIIIIOOZOZOOOZ7IIIIZZZZZIIIIIIIIIIOIMMM8I
# MMMMM78OZZMMMMMMMMMMMMMMO7OZI777$ZZ$ZZZZOZZOZ77$?++=++++??I$IIOZOOOZZZOZZ7IIIIZZZZZO$IIIIIIIIZOMMM8I
# MMMMM78ZOMMMMMMMMMMMMMMMM$8Z7$DMMMMMMDOOOOZ++=++??+~=+++++?I??OOZZZOZZZZZIIII$ZZZOMMMNZ7III77ZZ8MM8I
# MMMMM$8ZMMMMMMMMMMMMMMMMMM7I8MMMMMMD==++++++++++=?=~=++++++???++++++++MMMOIIIOZZOMMMMMIIZ777$ZZ$MMN$
# MMMMM8ODMMMMMMMMMMMMMMMMMMZ7MMMMMMI++INMM8OO????++=~+++++++?????I$8I++=NMMMIIOZOMMMMZIII7MZ$$ZZ7MMM8
# MMMMMMZMMMMMMMMMMMMMMMMMMMMMMMMMN+++MMMMMMOO$??++=~?+:::?I=??IO8MMMMD++=7MMNIO8MMMMINII+:$MDZZZIMMMM
# MMMMMM7MMMMMMMMMMMMMMMMMMMMMMZ+++++ZMMMMMM8+++++?:,,,::,,,,??IZMMMMMMM+++=?ODZMMMMNNZ?I=~DMMDZZIMMMM
# MMMMMMMDMMMMMMMMMMMMMMMMMMMN++Z+++++ZMMMM$++++?~,,,,:::,,:::~?7MMMMMMM+=+=?+INMMM7NOII?::+MMMZOIMMMM
# MMMMMMMMMMMMMMMMMMMMMMMMMMMM7OZ++DZ+$MMMZ++++I::,,,::,:,,::~=~7MMMMMM?++=++$++MM7NZI?~I+=:+MMOOIMMMM
# MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMZIMMM7$MMM+++++:::,,::::::,::~==~IMMMMN7IMM=+M$$MMNZII::++?IMMMDO7MMMM
# MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO++++I,::,:::,:::::::~====ZMMMMMMMMZZMNZ MZI?I?:::??MMMM$MMMMM
# MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMDI+++++=:,,,,,,,::::,,:====~7MMMMMMMD8IMMDNOI?I?=+:::?IIMMOMMMMM
# MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM?++++++=,::,,::::::::::======+NMN8 MMND88OZO7??I::?:::+:+7MMMMMMM
# MMMMMMMMMMMMMMMMMMMMMMMMO$II7$ODMM+=++++++?:,::::::::::::~=======?MD8OZZ$77II$$??II?::::::+IMMMMMMMM
# MMMMMMMMMMMMMMMMMMMMM$????I777777===+++++++~~::::::::::~~=======??I?ZII??????$I?III~::=+:+ZMMMMMMMMM
# MMMMMMMMMMMMMMMMMMM8??77I$777$$Z==~+++++++?~====~~:::~~=========7+==?7??????????IIZD?77I7MMMMMMMMMMM
# MMMMMMMMMMMMMMMMMMI???????????I++~=++++++??~====================?++++++????????II$8NMIMMMMMMMMMMMMMM
# MMMMMMMMMMMMMMMMMI????????????$+=~~+++++???~==================~I+++++++=Z?II??II7Z8I$MMMMMMMMMMMMMMM
# MMMMMMMMMMMMMMMM??????????II77?++=+++++???I==================~I?=++=++++=ZIIIII$$I77MMMMMMMMMMMMMMMM
# MMMMMMMMMMMMMMMNII???III77777Z?$++++?????===================I???++++++~+=Z7???II$I7MMMMMMMMMMMMMMMMM
# MMMMMMMMMMMMMMMMI777777777IIZI?????7??7I+===============~?Z7Z????+++++???$7$7IIIZ7DMMMMMMMMMMMMMMMMM
# MMMMMMMMMMMMMMMMD?7$$77II???Z????????O++=?I$7?++===+?$$IIIIIII7ZI????????$II$ZIII7OMMMMMMMMMMMMMMMMM
# MMMMMMMMMMMMMMMMMMI?????????$I???????7++++++?IZNNZ??III$Z$IIIIII7????????8ZZOZIIIIOMMMMMMMMMMMMMMMMM
# MMMMMMMMMMMMMMMMMMMMZ??????7=I?????I?NMMMMMMMNM8$??III7ZOOOZ$7III????I7I??OZZO7IIIOMMMMMMMMMMMMMMMMM
# MMMMMMMMMMMMMMMMMMMMMMMMMMM$+=+??????MMMMMMN8MO7??II$O8OZ$7IIIIIIZ??I=7?=$?ZZOZII?ZNMMMMMMMMMMMMMMMM
# MMMMMMMMMMMMMMMMMMMMMMMMMMM8.ZI,7?+78MMMMMDMDZI??I$O8OZ7IIIIIIIIIIIII$:O7,:OOZO7I?7DMMMMMMMMMMMMMMMM
# MMMMMMMMMMMMMMMMMMMMMMMMMMM:IM::DM,~MMMMM~M8$??I$O8Z$7IIIIIIIIIIIIIIIII7ZZZ8ZZO$III8MMMMMMMMMMMMMMMM
# MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMIMMMM8MMNOMDZ7?I$OOZ$7IIIIIIIIIIIIIIIIIII7ZZZOZZOO7I?ZMMMMMMMMMMMMMMMM
# MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMDMN8$I?7ZOO$7IIIIIIIIIIIIIIIIIIIII$ZZZOOZOO7I?7NMMMMMMMMMMMMMMM
# MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM M8$I?I$OOZ7IIIIIIIIIIIIIIIIIIIIIII$ZZZZ$$Z8$III8MMMMMMMMMMMMMMM



class User < ActiveRecord::Base
  include UserHelper

  attr_accessible :email, :name, :account_name, :password, :password_confirmation
  has_secure_password

  has_one :google_account
  has_one :drop_box_account
  has_one :setting
  #has_many :resources, order: 'title ASC, updated_at DESC'
  has_many :resources, order: 'updated_at DESC'
  has_many :maps, order: 'name ASC'

  serialize :options, Hash

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
    self.options = Hash.new
  end

  def create_remember_token
    self.remember_token ||= SecureRandom.urlsafe_base64
  end
end
