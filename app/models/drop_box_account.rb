require 'dropbox_sdk'


class DropBoxAccount < ActiveRecord::Base
  attr_accessible :session_token, :cursor, :file_hash
  belongs_to :user


  HOST = 'localhost:3000'
  if !ENV.nil? and ENV.has_key?('HOST_NAME')
  	HOST = ENV['HOST_NAME']
  end

  APP_KEY     = Rails.application.config.DROPBOX_APP_KEY
  APP_SECRET  = Rails.application.config.DROPBOX_APP_SECRET
  APP_FOLDER  = Rails.application.config.DROPBOX_APP_FOLDER
  ACCESS_TYPE = Rails.application.config.DROPBOX_ACCESS_TYPE
  CALLBACK = Rails.application.config.DROPBOX_CALLBACK

	
	def media_link(path)

		# Request public url that lasts 4 hours
		# media( path )
		
		# Request public url that lasts 20+ years
		shares( path )
	end

	def owned_by?( user )
    self.user_id == user.id
  end

	def folder_link
		"https://www.dropbox.com/home/Apps/#{APP_FOLDER}"
	end

	# Generate OAuth request
	def fetch_request()

    db_session = DropboxSession.new(APP_KEY, APP_SECRET)
    begin
    	db_session.get_request_token
      #Rails.logger.info("Session: #{db_session.serialize} URL: #{db_session.get_authorize_url(CALLBACK)}")
      return {request_db_session: db_session.serialize, auth_url: db_session.get_authorize_url(CALLBACK) }
    rescue DropboxError => e

      Rails.logger.info("Oh..no.. DropBox session request broke")   
      return false
    end

	end

  # Called during at OAuth
	def fetch_tokens(auth_code)

		# Authenticated access code provided, fetch tokens
		drop_box_session = DropboxSession.deserialize(auth_code)
			
    begin
      drop_box_session.get_access_token
    rescue DropboxError => e
      Rails.logger.info("Oh..no.. DropBox second step broke.")   
      return false
    end

    Rails.logger.info("DropBox OAuth Token: #{drop_box_session.serialize}")

    # Update tokens
    self.session_token = drop_box_session.serialize      
    self.save
	end

	def delete_file(path)
		delete(path)
	end

	def sync_files()

		# Grab user, not sure if this query is needed
		@current_user = User.find( self.user.id )
		# Grab user's resources
		@resources = Resource.where( user_id: self.user.id, type: DropBoxResource::TYPE )

		# Hash to save number of sync/updated files
		sync_count = Hash.new
		queryset = list_folder('/', true)
    # Rails.logger.info "State: #{queryset.inspect}"
		# queryset = state['contents']
		Rails.logger.info("Queryset: #{queryset}")

		# Create Dictonary {File_ID => DropBox Resource} to easily check if a file exists
  	resources_by_path  = Hash[@resources.map { |p| [p.path, p] }]
      	      	
		queryset.each do |resource|
			# Child is a tuple
			path = resource['path']

			# Rails.logger.info("Referencing: #{path}")

			# Skip if directory or folder
			next if resource['is_dir']

			if resource['is_deleted'] 
				if resources_by_path.has_key?(resource['path'])
					# File is marked deleted and has yet to be deleted in TeacherMaps database

	      	Rails.logger.info("Deleting DropBox Resource: #{resource['path']} Trashed?: #{resource['is_deleted']}")
	      
	    		# Add to sync
	    		sync_count[path] = true
	    		# Delete reource from TeacherMaps
	    		resources_by_path[resource['path']].destroy
				end

				# Move to next file
      	next
      end


			if !resources_by_path.has_key?(path)

				Rails.logger.info("Creating New Resource #{path}, Rev: #{resource['rev']}")  

				dropbox_resource = DropBoxResource.create( 
					rev: resource['rev'], path: path,
					title: File.basename(path),
      		mime_type: resource['mime_type'], 
      		file_size: resource['bytes']  
				)

				# Determine and assign Resource Type
      	dropbox_resource.assign_type

				# Grab public DropBox link
				dropbox_resource.link = media_link( dropbox_resource.path )
	
				@current_user.resources << dropbox_resource

				# Increment sync count
				sync_count[path] = true
			else
				Rails.logger.info("Found Existing Resource #{path}...just keep swimmming")
			end
    end

    # Commit resources, not sure if needed
		@current_user.save()

    # Save cursor
    self.save()

		return sync_count.length
	end


	private 

	# If we already have an authorized DropboxSession, returns a DropboxClient.
	def api_client( )
    if self.session_token?
      db_session = DropboxSession.deserialize(self.session_token)
      begin
        return DropboxClient.new(db_session, ACCESS_TYPE)
      rescue DropboxAuthError => e
      	Rails.logger.info("Could not authenticate DropBox Account" )
      end
    else
    	Rails.logger.info("User does not have a DropBox Account" )
    end

  	return nil    
	end


	def list_folder( path='/', recursive=false)
		@client ||= api_client()
	   
    results = []
    begin
      entry = @client.metadata(path,25000, true, nil, nil, include_deleted=true)
    rescue DropboxAuthError => e
      Rails.logger.info("DropBox Authentication Error")  
    rescue DropboxError => e
      Rails.logger.info("DropBox Error")  
    end

    entry['contents'].each do |child|
    	cp = child['path']
      #Rails.logger.info("DropBox File #{cp}")
      if recursive and child['is_dir']
        Rails.logger.info "Dropbox Folder Found: #{cp}"
        # Merge recursive results
        results.concat(list_folder(child['path'], true))
      end
    end
    results.concat(entry['contents'])
    results
	end

	def media( path=nil )
		
		return false if path.nil?

		@client ||= api_client( )

		begin
      entry = @client.media(path)
      entry['url']
	  rescue DropboxAuthError => e
      Rails.logger.info("DropBox Authentication Error")  
      false
	  rescue DropboxError => e
      Rails.logger.info("DropBox Error")  
      false
	  end

	end

	def delta( cursor=nil, entries=[] )
		@client ||= api_client( )
	   
    begin
      entry = @client.delta(cursor)
    rescue DropboxAuthError => e
      Rails.logger.info("DropBox Authentication Error")  
    rescue DropboxError => e
      Rails.logger.info("DropBox Error")  
    end

    Rails.logger.info("DropBox Delta Entries #{entry.inspect}")  

    return entry
	end

	def shares( path=nil )

		return nil if path.nil?
	    
    @client ||= api_client( )
    begin
      entry = @client.shares( "/#{path}" )

      Rails.logger.info("DropBox Sharable: #{entry}")  
      entry['url']
    rescue DropboxAuthError => e
      Rails.logger.info("DropBox Authentication Error")  
      false
    rescue DropboxError => e
      Rails.logger.info("DropBox Error")  
      false
    end

	end 

	def delete( path=nil )

		return nil if path.nil?
	    
    @client ||= api_client( )
    begin
      entry = @client.file_delete( "/#{path}" )

      Rails.logger.info("Deleted File: #{entry['path']}")  
      true
    rescue DropboxAuthError => e
      Rails.logger.info("DropBox Authentication Error")  
      false
    rescue DropboxError => e
      Rails.logger.info("DropBox Error")  
      false
    end

	end 
end
