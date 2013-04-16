class MapObjectiveResource < MapResource
	# Needed to cram Objective type Resources into MapResources
	belongs_to :map_objective

  before_create :before_creation
  before_destroy :before_deletion

  private 

  def before_deletion
    if self and self.map
      Map.decrement_counter :resources_count, self.map.id
    end
    if self and self.map_objective and self.map_objective.map_standard
      MapStandard.decrement_counter :resources_count, self.map_objective.map_standard.id
    end
  end
  
  def before_creation
    if self and self.map
      Map.increment_counter :resources_count, self.map.id
    end
    if self and self.map_objective and self.map_objective.map_standard
      MapStandard.increment_counter :resources_count, self.map_objective.map_standard.id
    end
  end

end
