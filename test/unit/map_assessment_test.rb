require 'test_helper'

class MapAssessmentTest < ActiveSupport::TestCase
  setup :initialize_user
  
  # Make sure our users have the necessary attributes
  test "should respond to attributes" do    
    assert_respond_to @map_assessment, :slug, "Map Assessment missing slug."
    assert_respond_to @map_assessment, :user, "Map Assessment missing user."
    assert_respond_to @map_assessment, :map,  "Map Assessment missing map."
    assert_respond_to @map_assessment, :name, "Map Assessment missing name."
    assert_respond_to @map_assessment, :text, "Map Assessment missing text."   
  end

  # Basic checks for name existence and length
  test "map assessment name must have valid format" do
    
    @map_assessment.name = "a"
    assert !(@map_assessment.valid?), "Map Assessment created with invalid name."

    @map_assessment.name = "a "
    assert !(@map_assessment.valid?), "Map Assessment created with invalid name."

    @map_assessment.name = " a"
    assert !(@map_assessment.valid?), "Map Assessment created with invalid name."

    @map_assessment.name = "\ta"
    assert !(@map_assessment.valid?), "Map Assessment created with invalid name."

    @map_assessment.name = "a\t"
    assert !(@map_assessment.valid?), "Map Assessment created with invalid name."

    @map_assessment.name = "a"*251
    assert !(@map_assessment.valid?), "Map Assessment Objective created with to long of a name."
    
    @map_assessment.name = "a"*2
    assert @map_assessment.valid?, "Map Assessment not created with valid name."

    @map_assessment.name = "a"*3
    assert @map_assessment.valid?, "Map Assessment not created with valid name."

    @map_assessment.name = "a"*250
    assert @map_assessment.valid?, "Map Assessment not created with valid name."

    @map_assessment.name = nil
    assert @map_assessment.valid?, "Map Assessment not created without name."
  end  


  # Basic checks for text existence and length
  test "map assessment text must have valid format" do
    
    @map_assessment.text = "a"
    assert !(@map_assessment.valid?), "Map Assessment created with invalid text."

    @map_assessment.text = "a "
    assert !(@map_assessment.valid?), "Map Assessment created with invalid text."

    @map_assessment.text = " a"
    assert !(@map_assessment.valid?), "Map Assessment created with invalid text."

    @map_assessment.text = "\ta"
    assert !(@map_assessment.valid?), "Map Assessment created with invalid text."

    @map_assessment.text = "a\t"
    assert !(@map_assessment.valid?), "Map Assessment created with invalid text."

    @map_assessment.text = "a"*2049
    assert !(@map_assessment.valid?), "Map Assessment created with to long of a text."

    @map_assessment.text = "a"*2
    assert @map_assessment.valid?, "Map Assessment not created with valid text."

    @map_assessment.text = "a"*3
    assert @map_assessment.valid?, "Map Assessment not created with valid text."

    @map_assessment.text = "a"*2048
    assert @map_assessment.valid?, "Map Assessment not created with valid text."

    @map_assessment.text = nil
    assert @map_assessment.valid?, "Map Assessment not created without text."
  end  

  # Make sure our Map Assessment has the necessary map
  test "map assessment should have valid map" do    
  	@map_assessment.map = nil
    assert !(@map_assessment.valid?), "Map validated without map."
    @map_assessment.map = maps(:map_one)
    assert @map_assessment.valid?, "Map not valid with valid map."
  end

  # Checks uniquness of Map Assessment's slug
  test "map assessment must have unique slug" do
    @map_assessment2 = @map_assessment.dup
    assert !(@map_assessment2.valid?), 'Map objective was validated with duplicate slug.' 
    assert !(@map_assessment2.save),   'Map objective was created with duplicate slug.'
  end

  # Checks for map resources manipulation
  test "map assessment resources test" do
    @map_assessment.map_resources = []
    assert_equal @map_assessment.map_resources, [], "Map Assessment Map resources assignment is not working."
    
    @map_assessment.map_resources << [map_resources(:map_resource_one), map_resources(:map_resource_two)]
    assert_equal @map_assessment.map_resources.length, 2, 'Map has incorrect number of map resources'
    
    @map_assessment.map_resources = []
    assert_equal @map_assessment.map_resources.length, 0, 'Map Standard has did not delete map resources'
  end

  
  private
  
  def initialize_user

    @map_assessment = MapAssessment.new
    @map_assessment.map = maps(:map_one)        
    @map_assessment.user = users(:billy_joe)

    assert @map_assessment.valid?, "Initialized map standard was not valid."
    assert @map_assessment.save, "Unable to save valid map standard." 
  end
end
