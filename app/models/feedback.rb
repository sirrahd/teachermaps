class Feedback
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :time, :page, :agent, :host, :message, :name, :account_name, :email

  validates_presence_of :time, :page, :agent, :host, :message

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end
