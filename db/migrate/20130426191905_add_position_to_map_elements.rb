class AddPositionToMapElements < ActiveRecord::Migration
  def self.up
    add_column :map_standards, :position, :integer, default: 0
    add_column :map_resources, :position, :integer, default: 0
    add_column :map_objectives, :position, :integer, default: 0
    add_column :map_assessments, :position, :integer, default: 0


    # For each map element, add positions based of date of DESC create_date
    # User.all.each do |user|
    #   counter = 0
    #   user.map_standards.each do |map_standard|
    #     map_standard.position = counter
    #     map_standard.save
    #     counter += 1
    #   end
    #   user.map_resources.each do |map_resource|
    #     map_resource.position = counter
    #     map_resource.save
    #     counter += 1
    #   end
    #   user.map_objectives.each do |map_objective|
    #     map_objective.position = counter
    #     map_objective.save
    #     counter += 1
    #   end
    #   user.map_assessments.each do |map_assessment|
    #     map_assessment.position = counter
    #     map_assessment.save
    #     counter += 1
    #   end
    # end

  end
  
  def self.down
    remove_column :map_standards, :position
    remove_column :map_resources, :position
    remove_column :map_objectives, :position
    remove_column :map_assessments, :position
    
  end
end
