class CreateResourceTypes < ActiveRecord::Migration
  def self.up
    create_table :resource_types do |t|

    	t.string :name
    	t.string :thumbnail

      
    end

    # Load in resource types
    load "#{Rails.root}/db/seeds.rb"

    add_column :resources, :resource_type_id, :integer
    
    conversion_table = ResourceType::MIME_TYPE_CONVERSIONS
    resources = Resource.all
    
    resources.each do |resource|
    	# Grab resoruce's mime type
    	mime_type = resource.mime_type

    	if mime_type.nil?
    		# Web content
    		resource.resource_type = ResourceType.find_by_name 'Web'
    	else
    		if conversion_table.has_key?(mime_type)
    			# If we have a mapping conversion
    			resource.resource_type = ResourceType.find_by_name conversion_table[mime_type]
    		else
    			# If we do not have a mapping conversion
    			resource.resource_type = ResourceType.find_by_name 'Other'
    		end
    	end

    	resource.save

    end # resources loop
  end #self.up


  def self.down
  	remove_column :resources, :resource_type_id
  	drop_table :resource_types
  end

end
