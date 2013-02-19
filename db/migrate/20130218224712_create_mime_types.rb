class CreateMimeTypes < ActiveRecord::Migration

  def self.up
    create_table :mime_types do |t|

      t.string :name
      t.string :mime_type
      t.string :thumbnail

    end
    
    rename_column :resources, :mime_type, :mime_type_old
    add_column :resources, :mime_type_id, :integer

    
    resources = Resource.all
    
    mime_types = MimeType::TYPES

    resources.each do |resource|
    	mime_type = nil

    	if mime_types.has_key?(resource.mime_type_old)
    		mime_type = MimeType.find_or_create_by_mime_type( :mime_type => resource.mime_type_old )
    		mime_type.name = mime_types[mime_type.name]
    		mime_type.save

    	else
    		mime_type = MimeType.create(:mime_type => mime_type['Web'], :name => 'Web' )
    		mime_type.save    		
    	end

    	resource.mime_type = mime_type
    	resource.save
    end

  end

  def self.down
  	rename_column :resources, :mime_type_old, :mime_type
  	remove_column :resources, :mime_type_id
  	drop_table :mime_types
  end
end
