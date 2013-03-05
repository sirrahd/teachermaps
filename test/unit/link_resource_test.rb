require 'test_helper'

class LinkResourceTest < ActiveSupport::TestCase
  setup :initialize_link_resource
  

  # Make sure our users have the necessary attributes
  test "should respond to attributes" do
    assert_respond_to @resource, :slug,  "Resource missing slug."
    assert_respond_to @resource, :title,  "Resource missing title name."
    assert_respond_to @resource, :user,  "Resource missing user."
    assert_respond_to @resource, :resource_type, "Resource missing resource type"
  end

  # Basic checks for name existence and length
  test "link resource must valid title" do
    
    @resource.link = nil
    assert !(@resource.valid?), "Resource created with nil link."

    @resource.link = 'www.pizza.com'
    assert !(@resource.valid?), "Resource created with invalid link."

    @resource.link = 'http:www.pizza'
    assert !(@resource.valid?), "Resource created with invalid link."

    @resource.link = 'pizza.com'
    assert !(@resource.valid?), "Resource created with invalid link."

    @resource.link = 'http://pizza'
    assert !(@resource.valid?), "Resource created with invalid link."

    @resource.link = 'http//pizza.com'
    assert !(@resource.valid?), "Resource created with invalid link."

    @resource.link = 'http:/pizza.com'
    assert !(@resource.valid?), "Resource created with invalid link."

    @resource.link = 'http:pizza.com'
    assert !(@resource.valid?), "Resource created with invalid link."

    @resource.link = 'http::pizza.com'
    assert !(@resource.valid?), "Resource created with invalid link."

    @resource.link = 'http:///pizza.com'
    assert !(@resource.valid?), "Resource created with invalid link."

    @resource.link = 'http://pizza.com'
    assert @resource.valid?, "Resource not created with valid link."

    @resource.link = 'http://www.google.co.uk/'
    assert @resource.valid?, "Resource not created with international valid link."

    @resource.link = 'http://www.bam.com'
    assert @resource.valid?, "Resource not created with valid link."

  end

  
  
  private
  
  def initialize_link_resource
  	
  	@resource = LinkResource.create :title => 'TestLinkResource', :link =>'http://valid-link.com'
    @resource.assign_type
  	@resource.user = users(:bjkiller)

  	assert @resource.valid?, 'Initialized resource was not valid.'
    assert @resource.save, 'Initialized resource was not saved.'
  	                      
  end
end
