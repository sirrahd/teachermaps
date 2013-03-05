class MapAssessmentResource < MapResource
	# Needed to cram Assessment type Resources into MapResources
	belongs_to :map_assessment 
end
