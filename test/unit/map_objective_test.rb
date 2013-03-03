require 'test_helper'

class MapObjectiveTest < ActiveSupport::TestCase
  setup :initialize_user
  
  # Make sure our users have the necessary attributes
  test "should respond to attributes" do    
    assert_respond_to @map_objective, :slug, "Map Objective missing slug."
    assert_respond_to @map_objective, :user, "Map Objective missing user."
    assert_respond_to @map_objective, :map,  "Map Objective missing map."
    assert_respond_to @map_objective, :name, "Map Objective missing name."
    assert_respond_to @map_objective, :map_standard, "Map Objective missing standard."
    
  end

  # Basic checks for name existence and length
  test "name must have valid format" do
    @map_objective.name = nil
    assert !(@map_objective.valid?), "Map created without name."

    @map_objective.name = "a"
    assert !(@map_objective.valid?), "Map created with invalid name."

    @map_objective.name = "a "
    assert !(@map_objective.valid?), "Map created with invalid name."

    @map_objective.name = " a"
    assert !(@map_objective.valid?), "Map created with invalid name."

    @map_objective.name = "\ta"
    assert !(@map_objective.valid?), "Map created with invalid name."

    @map_objective.name = "a\t"
    assert !(@map_objective.valid?), "Map created with invalid name."

    @map_objective.name = "a"*251
    assert !(@map_objective.valid?), "Map created with to long of a name."
    
    @map_objective.name = "a"*2
    assert @map_objective.valid?, "Map not created with valid name."

    @map_objective.name = "a"*3
    assert @map_objective.valid?, "Map not created with valid name."

    @map_objective.name = "a"*250
    assert @map_objective.valid?, "Map not created with valid name."
  end  

  # Make sure our MapStandard has the necessary map
  test "should have valid map" do    
  	@map_objective.map = nil
    assert !(@map_objective.valid?), "Map validated without map."
    @map_objective.map = maps(:map_one)
    assert @map_objective.valid?, "Map not valid with valid map."
  end

  # Make sure our MapObjectve has the necessary map standard
  test "map objective should have valid map standard" do    
  	@map_objective.map_standard = nil
    assert !(@map_objective.valid?), "Map Objective validated without map standard."
    @map_objective.map_standard = map_standards(:map_standard_one)
    assert @map_objective.valid?, "Map Objective not valid with valid map standard."
  end

  # Checks uniquness of MapStandard's slug
  test "map standard must have unique slug" do
    @map_objective2 = @map_objective.dup
    assert !(@map_objective2.valid?), 'Map objective was validated with duplicate slug.' 
    assert !(@map_objective2.save),   'Map objective was created with duplicate slug.'
  end

  
  private
  
  def initialize_user

    @user = User.new  name: "Example User", 
                      email: "user@example.org",
                      account_name: "example",
                      password: "foobar",
                      password_confirmation: "foobar"
                      
    assert @user.valid?, "Initialized user was not valid."
    assert @user.save, "Unable to save valid user."

    @map_objective = MapObjective.new name: 'Test Map Objective'
    @map_objective.map_standard = map_standards(:map_standard_one)
    @map_objective.map = maps(:map_one)        
    @map_objective.user = @user

    assert @map_objective.valid?, "Initialized map standard was not valid."
    assert @map_objective.save, "Unable to save valid map standard." 
  end
end
