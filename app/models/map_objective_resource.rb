class MapObjectiveResource < MapResource
	# Needed to cram Objective type Resources into MapResources
	belongs_to :map_objective
end
