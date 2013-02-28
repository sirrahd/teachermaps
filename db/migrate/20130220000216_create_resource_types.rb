class CreateResourceTypes < ActiveRecord::Migration
  def self.up
    create_table :resource_types do |t|
    	t.string :name
    	t.string :thumbnail      
    end

    # Load in resource types
    load "#{Rails.root}/db/seeds.rb"

    add_column :resources, :resource_type_id, :integer

    
    resources = Resource.all
    resources.each do |resource|
    	resource.assign_type()
    end

  end


  def self.down
  	remove_column :resources, :resource_type_id
  	drop_table :resource_types
  end

end
