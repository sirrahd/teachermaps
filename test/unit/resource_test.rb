require 'test_helper'

class ResourceTest < ActiveSupport::TestCase
  setup :initialize_resource
  

  # Make sure our users have the necessary attributes
  test "should respond to attributes" do
    assert_respond_to @resource, :slug,  "Resource missing slug."
    assert_respond_to @resource, :title,  "Resource missing title name."
    assert_respond_to @resource, :user,  "Resource missing user."
    assert_respond_to @resource, :resource_type, "Resource missing resource type"
  end

  # Basic checks for name existence and length
  test "resource must valid title" do
    # @resource.title = nil
    # assert !(@resource.valid?), "Resource created without title."

    @resource.title = ''
    assert !(@resource.valid?), "Resource created with empty title."

    @resource.title = 'a'
    assert !(@resource.valid?), "Resource created with two short of a title."

    @resource.title = 'aa'
    assert (@resource.valid?), "Resource created with incorrect error."
    
    @resource.title = "a" * 250
    assert (@resource.valid?), "Resource created with incorrect error."

    @resource.title = "a" * 251
    assert !(@resource.valid?), "Resource created with two long of a title."
  end


  # Checks for course grade manipulation
  test "resource must valid course grade" do

    @resource.course_grades = []
    assert_equal @resource.course_grades, [], "Resource created with a course grade."
    
    @resource.course_grades << [course_grades(:one), course_grades(:two)]
  	assert_equal @resource.course_grades.length, 2, 'Resource has incorrect number of course grades'


  	@resource.course_grades = []
  	assert_equal @resource.course_grades.length, 0, 'Resource has did not delete course grades'
   
  end

  # Checks for course subjects manipulation
  test "resource must valid course subjects" do
    
    @resource.course_subjects = []
    assert_equal @resource.course_subjects, [], "Resource created with a course subjects."

    @resource.course_subjects << [course_subjects(:math), course_subjects(:science)]
  	assert_equal @resource.course_subjects.length, 2, 'Resource has incorrect number of course subjects'

  	@resource.course_subjects = []
  	assert_equal @resource.course_subjects.length, 0, 'Resource has did not delete course subjects'
   
  end


  # Checks for course subjects manipulation
  test "resource must valid resource type" do
    
    @resource.mime_type = nil
    @resource.assign_type
    assert_equal @resource.resource_type, resource_types(:web) , 'Resource has an incorrect resourece type'

    @resource.mime_type = 'application/msword'
    @resource.assign_type
    assert_equal @resource.resource_type, resource_types(:document) , 'Resource has an incorrect resourece type'

    @resource.mime_type = 'application/vnd.ms-powerpoint'
    @resource.assign_type
    assert_equal @resource.resource_type, resource_types(:presentation) , 'Resource has an incorrect resourece type'

    @resource.mime_type = 'application/vnd.oasis.opendocument.spreadsheet'
    @resource.assign_type
    assert_equal @resource.resource_type, resource_types(:spreadsheet) , 'Resource has an incorrect resourece type'

    @resource.mime_type = 'image/png'
    @resource.assign_type
    assert_equal @resource.resource_type, resource_types(:image) , 'Resource has an incorrect resourece type'

    @resource.mime_type = 'audio/mpeg'
    @resource.assign_type
    assert_equal @resource.resource_type, resource_types(:audio) , 'Resource has an incorrect resourece type'

    @resource.mime_type = 'video/mp4'
    @resource.assign_type
    assert_equal @resource.resource_type, resource_types(:video) , 'Resource has an incorrect resourece type'

    @resource.mime_type = 'video/mp4'
    @resource.assign_type
    assert_not_equal @resource.resource_type, resource_types(:audio) , 'Resource has an incorrect resourece type'
    
  end
  
  
  private
  
  def initialize_resource
  	@user = User.new  name: "Example User", 
                      email: "user@example.org",
                      account_name: "example",
                      password: "foobar",
                      password_confirmation: "foobar"
                      
    assert @user.valid?, "Initialized user was not valid."
    assert @user.save, "Unable to save valid user."
  	

  	@resource = Resource.create title: 'TestResource'
  	@resource.user = @user

  	assert @resource.valid? 'Initialized resource was not valid.'
  	                      
  end
end
