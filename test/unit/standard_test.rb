require 'test_helper'

class StandardTest < ActiveSupport::TestCase
  setup :initialize_resource
  
  # Make sure our users have the necessary attributes
  test "standard should respond to attributes" do
    assert_respond_to @standard, :slug,  "Standard missing slug."
    assert_respond_to @standard, :name,  "Standard missing name."
    assert_respond_to @standard, :text,  "Standard missing text."
    assert_respond_to @standard, :domain,  "Standard missing domain."
    assert_respond_to @standard, :sub_subject,  "Standard missing sub subject."
    assert_respond_to @standard, :standard_type, "Standard missing standard type"
    assert_respond_to @standard, :parent_standard,  "Standard missing parent standard."
    assert_respond_to @standard, :children_standards,  "Standard missing childrent standards."
    assert_respond_to @standard, :is_parent_standard,  "Standard missing is a parent standard."
    assert_respond_to @standard, :course_subject,  "Standard missing course subject."
    assert_respond_to @standard, :course_grades,  "Standard missing course grades."
  end

  # Basic checks for name existence and length
  test "standard must valid name" do
    @standard.name = nil
    assert !(@standard.valid?), "Standard created without name."

    @standard.name = ''
    assert !(@standard.valid?), "Standard created with empty name."

    @standard.name = 'a'
    assert !(@standard.valid?), "Standard created with two short of a name."

    @standard.name = 'aa'
    assert (@standard.valid?), "Standard created with incorrect error."
    
    @standard.name = "a" * 250
    assert (@standard.valid?), "Standard created with incorrect error."

    @standard.name = "a" * 251
    assert !(@standard.valid?), "Standard created with two long of a name."
  end

  # Basic checks for text existence and length
  test "standard must valid text" do
    @standard.text = nil
    assert !(@standard.valid?), "Standard created without text."

    @standard.text = "a"
    assert !(@standard.valid?), "Standard created with invalid text."

    @standard.text = "a "
    assert !(@standard.valid?), "Standard created with invalid text."

    @standard.text = " a"
    assert !(@standard.valid?), "Standard created with invalid text."

    @standard.text = "\ta"
    assert !(@standard.valid?), "Standard created with invalid text."

    @standard.text = "a\t"
    assert !(@standard.valid?), "Standard created with invalid text."

    @standard.text = "a"*3501
    assert !(@standard.valid?), "Standard created with to long of a text."

    @standard.text = "a"*2
    assert @standard.valid?, "Standard not created with valid text."

    @standard.text = "a"*3
    assert @standard.valid?, "Standard not created with valid text."

    @standard.text = "a"*3499
    assert @standard.valid?, "Standard not created with valid text."
  end


  # Checks for course grade manipulation
  test "standard must valid course grade" do

    @standard.course_grades = []
    assert_equal @standard.course_grades, [], "Standard created with a course grade."
    
    @standard.course_grades << [course_grades(:one), course_grades(:two)]
  	assert_equal @standard.course_grades.length, 2, 'Standard has incorrect number of course grades'

  	@standard.course_grades = []
  	assert_equal @standard.course_grades.length, 0, 'Standard has did not delete course grades'
    
  end  
  
  private
  
  def initialize_resource
  	
    @standard = standards(:standard_8051b7d8d2cc77b2e3a73b0d7428454a71f1c011)
  
  	assert @standard.valid?, 'Initialized Standard was not valid.'
    assert @standard.save, 'Initialized Standard was not saved.'
  	                      
  end
end
