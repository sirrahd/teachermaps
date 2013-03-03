require 'test_helper'

class MapStandardTest < ActiveSupport::TestCase
  setup :initialize_user
  
  # Make sure our users have the necessary attributes
  test "should respond to attributes" do    
    assert_respond_to @map_standard, :slug,  	"Map Standard missing slug."
    assert_respond_to @map_standard, :user,  	"Map Standard missing user."
    assert_respond_to @map_standard, :standard, "Map Standard missing standard."
    assert_respond_to @map_standard, :map,      "Map Standard missing map."
  end

  # Make sure our MapStandard has the necessary map
  test "should have valid map" do    
  	@map_standard.map = nil
    assert !(@map_standard.valid?), "Map validated without map."
    @map_standard.map = maps(:map_one)
    assert @map_standard.valid?, "Map not valid with valid map."
  end

  # Make sure our MapStandard has the necessary standard
  test "should have valid standard" do    
  	@map_standard.standard = nil
    assert !(@map_standard.valid?), "Map validated without standard."
    @map_standard.standard = standards(:standard_0c58b3a43cd6b87290672514bce1afec3f471d18)
    assert @map_standard.valid?, "Map not valid with valid standard."
  end

  # Checks uniquness of MapStandard's slug
  test "map standard must have unique slug" do
    @map_standard2 = @map_standard.dup
    assert !(@map_standard2.valid?), 'Map was validated with duplicate slug.' 
    assert !(@map_standard2.save),   'Map was created with duplicate slug.'
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

    @map_standard = MapStandard.new 
    @map_standard.standard = standards(:standard_8051b7d8d2cc77b2e3a73b0d7428454a71f1c011)
    @map_standard.map = maps(:map_one)        
    @map_standard.user = @user

    assert @map_standard.valid?, "Initialized map standard was not valid."
    assert @map_standard.save, "Unable to save valid map standard." 
  end
end
