require 'test_helper'

class MapObjectiveResourceTest < ActiveSupport::TestCase
  setup :initialize_user
  
  # Make sure our users have the necessary attributes
  test "map objective resource should respond to attributes" do
    assert_respond_to @map_resource, :text, "Map Resource missing text."
    assert_respond_to @map_resource, :user, "Map Resource missing user."
    assert_respond_to @map_resource, :resource, "Map missing resource."
    assert_respond_to @map_resource, :map, "Map Resource missing map."
    assert_respond_to @map_resource, :map_objective, "Map Resource missing map map_objective."
  end

  # Basic checks for name existence and length
  test "map objective resource text must have valid format" do
    # @map_resource.text = nil
    # assert !(@map_resource.valid?), "Map Resource created without text."

    @map_resource.text = "a"
    assert !(@map_resource.valid?), "Map Resource created with invalid text."

    @map_resource.text = "a "
    assert !(@map_resource.valid?), "Map Resource created with invalid text."

    @map_resource.text = " a"
    assert !(@map_resource.valid?), "Map Resource created with invalid text."

    @map_resource.text = "\ta"
    assert !(@map_resource.valid?), "Map Resource created with invalid text."

    @map_resource.text = "a\t"
    assert !(@map_resource.valid?), "Map Resource created with invalid text."

    @map_resource.text = "a"*2049
    assert !(@map_resource.valid?), "Map Resource created with to long of a text."

    @map_resource.text = "a"*2
    assert @map_resource.valid?, "Map Resource not created with valid text."

    @map_resource.text = "a"*3
    assert @map_resource.valid?, "Map Resource not created with valid text."

    @map_resource.text = "a"*2048
    assert @map_resource.valid?, "Map Resource not created with valid text."
  end  
  
  private
  
  def initialize_user

    @map_resource = MapObjectiveResource.new text: 'This is a sample text description for a map resource.'
    @map_resource.user = users(:billy_joe)
    @map_resource.map = maps(:map_one)
    @map_resource.map_objective = map_objectives(:map_objective_one)
    @map_resource.resource = resources(:resource_one)

    assert @map_resource.valid?, "Initialized map objresourceective was not valid."
    assert @map_resource.save, "Unable to save valid map resource." 
  end
end
