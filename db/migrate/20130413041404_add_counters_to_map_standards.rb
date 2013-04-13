class AddCountersToMapStandards < ActiveRecord::Migration
  def self.up
    add_column :map_standards, :resources_count, :integer, :default => 0
    add_column :map_standards, :objectives_count, :integer, :default => 0


    # Update all objective and resource counters
    MapStandard.all.each do |map_standard|

      map_standard.objectives_count = map_standard.map_objectives.count
      map_standard.resources_count = map_standard.map_objectives.map{|a| a.map_resources.count}.sum
      map_standard.save

    end

    # Separate from map_standard_counters, this updates maps metadata
    Map.all.each do |map|
      map.update_metadata
    end

  end
  
  def self.down
    remove_column :map_standards, :resources_count
    remove_column :map_standards, :objectives_count
  end
end
