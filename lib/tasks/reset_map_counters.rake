

namespace :admin  do
  desc "Update the map and map standard counters."
  task :reset_map_counters => :environment do

    print "Updating the map counters.\n"
    Map.all.each do |map|

      map.objectives_count = 0
      map.resources_count  = 0
      map.standards_count  = 0

      # For every Map Standards
      map.map_standards.each do |map_standard|
        map.standards_count += 1

        map_standard.map_objectives.each do |map_objective|
          # Maps counters
          map.objectives_count += 1
          map.resources_count  += map_objective.map_resources.count

          # Map Standards counters
          map_standard.objectives_count += 1
          map_standard.resources_count  += map_objective.map_resources.count
        end
      end

      # For every Map Assessment
      map.map_assessments.each do |map_assessment|
        map.resources_count += map_assessment.map_resources.count
      end

      map.save

    end

    print "Have a nice day #{ENV['USER']}\n"
  end
end