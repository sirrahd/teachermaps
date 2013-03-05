require 'test_helper'

class MapTest < ActiveSupport::TestCase
  setup :initialize_user
  
  # Make sure our users have the necessary attributes
  test "should respond to attributes" do
    assert_respond_to @map, :name,  "Map missing name."
    assert_respond_to @map, :slug,  "Map missing slug."
    assert_respond_to @map, :user,  "Map missing user."
    assert_respond_to @map, :resources_count,  "Map missing resources count."
    assert_respond_to @map, :objectives_count, "Map missing objectives count."
    assert_respond_to @map, :standards_count,  "Map missing standards count."  
    assert_respond_to @map, :map_standards,    "Map missing map standards."  
    assert_respond_to @map, :map_assessments,  "Map missing map objectives."  
  end
  
  # Basic checks for name existence and length
  test "name must have valid format" do
    @map.name = nil
    assert !(@map.valid?), "Map created without name."

    @map.name = "a"
    assert !(@map.valid?), "Map created with invalid name."

    @map.name = "a "
    assert !(@map.valid?), "Map created with invalid name."

    @map.name = " a"
    assert !(@map.valid?), "Map created with invalid name."

    @map.name = "\ta"
    assert !(@map.valid?), "Map created with invalid name."

    @map.name = "a\t"
    assert !(@map.valid?), "Map created with invalid name."

    @map.name = "a"*251
    assert !(@map.valid?), "Map created with to long of a name."
    
    @map.name = "a"*2
    assert @map.valid?, "Map not created with valid name."

    @map.name = "a"*3
    assert @map.valid?, "Map not created with valid name."

    @map.name = "a"*250
    assert @map.valid?, "Map not created with valid name."
  end  



  # Basic checks for name existence and length
  test "text must have valid format" do
    @map.text = nil
    assert !(@map.valid?), "Map created without text."

    @map.text = "a"
    assert !(@map.valid?), "Map created with invalid text."

    @map.text = "a "
    assert !(@map.valid?), "Map created with invalid text."

    @map.text = " a"
    assert !(@map.valid?), "Map created with invalid text."

    @map.text = "\ta"
    assert !(@map.valid?), "Map created with invalid text."

    @map.text = "a\t"
    assert !(@map.valid?), "Map created with invalid text."

    @map.text = "a"*2049
    assert !(@map.valid?), "Map created with to long of a text."

    @map.text = "a"*2
    assert @map.valid?, "Map not created with valid text."

    @map.text = "a"*3
    assert @map.valid?, "Map not created with valid text."

    @map.text = "a"*2048
    assert @map.valid?, "Map not created with valid text."
  end  

  # Checks for map standards manipulation
  test "maps standards test" do
    @map.map_standards = []
    assert_equal @map.map_standards, [], "Map' map_standards assignment is not working."
    
    @map.map_standards << [map_standards(:map_standard_one), map_standards(:map_standard_two)]
    assert_equal @map.map_standards.length, 2, 'Map has incorrect number of map standards'
    
    @map.map_standards = []
    assert_equal @map.map_standards.length, 0, 'Map has did not delete mapstandards'
  end

  # Checks for course grade manipulation
  test "map must valid course grade" do
    @map.course_grades = []
    assert_equal @map.course_grades, [], "Map created with a course grade."
    
    @map.course_grades << [course_grades(:one), course_grades(:two)]
    assert_equal @map.course_grades.length, 2, 'Map has incorrect number of course grades'


    @map.course_grades = []
    assert_equal @map.course_grades.length, 0, 'Map has did not delete course grades'
  end

  # Checks for course subjects manipulation
  test "map must valid course subjects" do
    @map.course_subjects = []
    assert_equal @map.course_subjects, [], "Map created with a course subjects."

    @map.course_subjects << [course_subjects(:math), course_subjects(:science)]
    assert_equal @map.course_subjects.length, 2, 'Map has incorrect number of course subjects'

    @map.course_subjects = []
    assert_equal @map.course_subjects.length, 0, 'Map has did not delete course subjects'
  end

  # Checks for map assessments manipulation
  test "map must valid map assessments" do
    @map.map_assessments = []
    assert_equal @map.map_assessments, [], "Map created with a course subjects."

    @map.map_assessments << [map_assessments(:map_assessment_one), map_assessments(:map_assessment_two)]
    assert_equal @map.map_assessments.length, 2, 'Map has incorrect number of course subjects'

    @map.map_assessments = []
    assert_equal @map.map_assessments.length, 0, 'Map has did not delete course subjects'
  end

  # Checks for course subjects manipulation
  test "map must unique slug" do
    @map2 = @map.dup
    assert !(@map2.valid?), 'Map was created with duplicate slug.' 
    assert !(@map2.save),   'Map was created with duplicate slug.'
  end
  
  private
  
  def initialize_user

    @map = Map.new name: 'Map Unit Test',
                   text: 'This is a sample text description.'
    @map.user = users(:bjkiller)


    assert @map.valid?, "Initialized map was not valid."
    assert @map.save, "Unable to save valid map." 
  end
end
