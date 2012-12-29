# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  slug       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  url        :string(255)
#  type       :integer
#

class ResourceType < ActiveRecord::Base
  attr_accessible :name

  validates :name, presence: true, length: { maximum: 100 }
end



class Resource < ActiveRecord::Base
  attr_accessible :slug, :url
  belongs_to :resource_type
    
  before_save do |resource|
    # Do some edits
  end
  
  
end
