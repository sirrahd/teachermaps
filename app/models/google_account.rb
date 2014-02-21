require 'google/api_client'

class GoogleAccount < ActiveRecord::Base

  MAX_NUM_FILES = 25000
  
	# Google OAuth data
	attr_accessible :access_token, :refresh_token, :expires_in, :issued_at

	belongs_to :user

	# TeacherMaps Google Drive folder id
	attr_accessible :folder_id

	# ID of last Google Drive change, may not need
	attr_accessible :largest_change_id 

	# Not stored in database
	attr_accessible :authorization_url

  def owned_by?( user )
    self.user_id == user.id
  end
	
	# Link to Google Drive Folder which is synced with TeacherMaps
	def drive_folder_link
		"https://drive.google.com/#folders/#{self.folder_id}"
	end

	# Generates Ouath URL Request
	def authorization_url
		@client ||= api_client()
		@client.authorization.authorization_uri.to_s
	end 

	# Gets/Updates OAuth tokens needed for Google API
	def fetch_tokens(auth_code, save=false)
		@client ||= api_client()
    @client.authorization.code = auth_code
    @client.authorization.fetch_access_token!

    self.refresh_token = @client.authorization.refresh_token
  	self.access_token  = @client.authorization.access_token
  	self.expires_in    = @client.authorization.expires_in
  	self.issued_at     = @client.authorization.issued_at

  	self.save() if save
	end

	# Typical binary data file, Non-Google Document... Not Tested!!!
	def create_file(title, description, parent_id, mime_type, file_name)
  	insert_file(title, description, parent_id, 'application/vnd.google-apps.file', file_name)
	end

	# Google Document... Not Tested!!!
	def create_google_document(title, description, parent_id, mime_type, file_name)
	  insert_file(title, description, parent_id, 'application/vnd.google-apps.document', file_name)
	end

	# Google Folder
	def create_folder(title, description, parent_id=nil)
	  insert_file(title, description, parent_id, 'application/vnd.google-apps.folder')
	end

	# Photo file... Not Tested!!!
	def create_image(title, description, parent_id, mime_type, file_name)
	  insert_file(title, description, parent_id, 'application/vnd.google-apps.photo', file_name)
	end

	# Video file... Not Tested!!!
	def create_image(title, description, parent_id, mime_type, file_name)
	  insert_file(title, description, parent_id, 'application/vnd.google-apps.video', file_name)
	end


	def search_for_teachermaps_folder()
 
 		folder_id = false
 		# Grab 10 files named 'TeacherMaps'
		teachermaps_folder = list_files( nil,'TeacherMaps', 10, 'application/vnd.google-apps.folder')
		# Grab 10 files named 'Apps' which are located in the root directory
		apps_folder = list_files( 'root', 'Apps', 10, 'application/vnd.google-apps.folder' )		
		# Organize 
		apps_folders_by_id = Hash[apps_folder.map { |p| [p['id'], p] }]
		

		# Rails.logger.info("Found TeacherMap Folders #{teachermaps_folder.inspect}")


		# For each TeacherMaps folder in Google Drive
		teachermaps_folder.each do |folder|

			folder['parents'].each do |parent_reference|

				#begin # I hate using these things....

				# Skip if Apps id was not found to link to this folder
				#next if !apps_folders_by_id.has_key?(parent_reference['id'])

				candidate_parent = apps_folders_by_id[parent_reference['id']]

				# Check if parent title is "Apps" and folder title is "TeacherMaps"
				if !candidate_parent.nil? and candidate_parent['title'] == 'Apps' and folder['title'] == 'TeacherMaps'
					# Rails.logger.info("Found /Apps/TeacherMaps: #{parent_reference['id']} #{apps_folders_by_id.keys}")
					# Return TeacherMaps folder id
					return folder['id']
				end

				# Rails.logger.info("Found /Apps/TeacherMaps: /#{candidate_parent['title']}/#{folder['title']}") if !candidate_parent.nil?
				# rescue
				# 	next
				# end

				#Rails.logger.info("No Match: #{parent_reference['id']} #{apps_folders_by_id.keys}")
			end
		end

		folder_id
	end

	def create_teachermaps_folder(save=false)
		app_folder = create_folder("Apps", "Store and Organize all your teaching materials");
    teachermaps_folder = create_folder("TeacherMaps", "Store and Organize all your teaching materials", app_folder['id']);
    self.folder_id = teachermaps_folder['id']

    self.save() if save
    self.folder_id
	end

	def teachermaps_files()
                #folder_id=nil, title=nil, max_results=MAX_NUM_FILES, mime_type=nil, trashed=false, recursive=false
    list_files( self.folder_id, nil, MAX_NUM_FILES, nil, false, true )
	end


	def delete_file(file_id)
		return trash_file(file_id)
	end

	def change_file_name(file_id, name)
		rename_file(file_id, name)
	end



	def sync_files()

		# Grab user, not sure if this query is needed
		@current_user = User.find( self.user.id )
		# Grab user's resources
		@resources = Resource.where( :user_id => self.user.id, :type=>GoogleResource::TYPE )

		# Hash to save number of sync/updated files
		sync_count = Hash.new

		google_files  = self.teachermaps_files()

  	# Create Dictonary {File_ID => Google Resource} to easily check if a file exists
  	resources_by_id = Hash[@resources.map { |p| [p['file_id'], p] }]
  	resources_touched = Hash[@resources.map { |p| [p['file_id'], true] }]
  	
  	# Rails.logger.info("Resources by id: #{resources_by_id}")
  	google_files.each do |file|

  		# Skip if resource folder
			next if file['mimeType'] == 'application/vnd.google-apps.folder'
			# Rails.logger.info("Is resource in the correct folder?: #{in_correct_folder}")


      if file['labels']['trashed'] == true 
        # File is marked deleted and has yet to be deleted in TeacherMaps database

        # Rails.logger.info("Deleting Resource: #{file['title']} Trashed?: #{file['labels']['trashed']}")
        google_resource = resources_by_id[file['id']]

        if !google_resource.nil?
        	# Add to sync
        	sync_count[file['id']] = true

        	google_resource.destroy
        	# Mark resource as touched
        	resources_touched.delete(file['id']) if resources_touched.has_key?(file['id'])
        end

        # Move to next file
        next
      end

      if resources_by_id.has_key?(file['id'])
      	# Exists in TeacherMaps database
        
      	# Rails.logger.info("Found Existing Resource: #{file['title']} Trashed?: #{file['labels']['trashed']}")

      	# Check if title has be changed
      	google_resource = resources_by_id[file['id']]
      	if file['title'] != google_resource.title
        	google_resource.title = file['title']
        	google_resource.save

        	sync_count[file['id']] = true
      	end

      	resources_touched.delete(file['id']) if resources_touched.has_key?(file['id'])
        
      else
      	# Does not exist in TeacherMaps database

      	# Rails.logger.info("Found New Resource: #{file['title']} Trashed?: #{file['labels']['trashed']}")
      	google_resource = GoogleResource.create( 
      		:file_id=>file['id'], 
      		:title=>file['title'], 
      		:mime_type=> file['mimeType'], 
      		:file_size=>file['fileSize']  
      	)

      	# Determine and assign Resource Type
      	google_resource.assign_type

      	# Rails.logger.info("New Google Resource: #{google_resource.inspect}")
      
      	# Add to temp reference dictionary, possibly do not need
      	resources_by_id[google_resource.file_id] = google_resource
      
      	# Add GoogleResource to User
      	@current_user.resources << google_resource

      	# Increment File Sync Count
      	sync_count[file['id']] = true

      	# Make google file world readable
      	enable_world_readable(file['id'])
      end

  	end 

    	# Delete any local google resource if they have not been touched
    	resources_touched.each_pair do |x,v|
  		# Rails.logger.info("Deleting #{resources_by_id[x].title}")
  		file = resources_by_id[x]
  		sync_count[file.file_id] = true
  		file.destroy
  	end

    # Save all new resources
    @current_user.save()

    sync_count.length
	end

	def enable_world_readable(file_id)
		update_permission(file_id, 'reader', 'anyone')
	end

	##
	# Retrieve a list of permissions.
	#
	# @param [Google::APIClient] client
	#   Authorized client instance
	# @param [String] file_id
	#   ID of the file to retrieve permissions for
	# @return [Array]
	#   List of permissions
	def retrieve_permissions(file_id)
		@client ||= api_client()

	  api_result = @client.execute(
	    :api_method => @drive.permissions.list,
	    :parameters => { 'fileId' => file_id })
	  if api_result.status == 200
	    permissions = api_result.data
	    permissions.items.each do |perm|
	    	if perm['role'] == 'owner'
	    		Rails.logger.info "Found Permission #{perm['id']}"
	    		return perm['id']
	    	end
	    end
	  else
	    Rails.logger.info "An error occurred: #{api_result.data['error']['message']}"
	  end

	  return false
	end

	def update_permission(file_id, new_role, who)
		@client ||= api_client()

		# Retrieve permission id if not given
		permission_id ||= retrieve_permissions(file_id)

	  result = @client.execute(
	    :api_method => @drive.permissions.get,
	    :parameters => {
	      'fileId' => file_id,
	      'permissionId' => permission_id
	    })

	  if result and result.status == 200
	    permission = result.data
	    permission.role = new_role
	    permission.type = who
	    result = @client.execute(
	      :api_method => @drive.permissions.insert,
	      :body_object => permission,
	      :parameters => {
	        'fileId' => file_id,
	        'permissionId' => permission_id
	      })
	    if result.status == 200
	      return result.data
	    end
	  end
	  Rails.logger.info "An error occurred: #{result.data['error']['message']}"
	end







	private 

	def api_client()
		@client ||= (begin
			client = Google::APIClient.new

			client.authorization.client_secret = Rails.application.config.CLIENT_SECRET
			client.authorization.redirect_uri  = Rails.application.config.REDIRECT_URI
			client.authorization.client_id     = Rails.application.config.CLIENT_ID
			client.authorization.scope         = Rails.application.config.SCOPES

			client
		end)

		# So this catches the google discovery api bug
		# https://groups.google.com/forum/#!msg/google-latitude-api/9ZtnLpOyCJk/F9kZ58xfWEIJ
		while true
			begin
				@drive = @client.discovered_api('drive', 'v2')
				# Rails.logger.info("Discovery Success")
				break
			rescue
				# Rails.logger.info("Discovery Failure")
				next
			end
		end

		# Rails.logger.info("Client: #{@drive.inspect}}")

		@client.authorization.access_token  = self.access_token
    @client.authorization.refresh_token = self.refresh_token
    @client.authorization.expires_in    = self.expires_in
    @client.authorization.issued_at     = self.issued_at

		@client
	end


  def build_parameters( folder_id=nil, title=nil, max_results=MAX_NUM_FILES, mime_type=nil, trashed=false )
    parameters = {}
    if !max_results.nil?
      # Max number of results returned
      parameters['maxResults'] = max_results
    end

    if !folder_id.nil?
       # Only return files with this parent
       parameters['q'] = "'#{folder_id}' in parents"
    end  

    if !parameters.has_key?('q') and !mime_type.nil?
       parameters['q'] = " mimeType = '#{mime_type}'"
    elsif !mime_type.nil?
       parameters['q'] = "#{parameters['q']} and mimeType = '#{mime_type}'"
    end  

    if !parameters.has_key?('q')
       parameters['q'] = "trashed = #{trashed}"
    else
       parameters['q'] = "#{parameters['q']} and trashed = #{trashed}"
    end  

    if !parameters.has_key?('q') and !title.nil?
       parameters['q'] = " title = '#{title}'"
    elsif !title.nil?
       parameters['q'] = "#{parameters['q']} and title = '#{title}'"
    end  
    parameters
  end


	def list_files( folder_id=nil, title=nil, max_results=MAX_NUM_FILES, mime_type=nil, trashed=false, recursive=false )
    Rails.logger.info "Are we recursive #{recursive}"
		@client ||= api_client()

    result = Array.new
    parameters = build_parameters( folder_id, title, max_results, mime_type, trashed )

    api_result = @client.execute(
      :api_method => @drive.files.list,
      :parameters => parameters)

    if api_result.status == 200
      	children = api_result.data
      	children.items.each do |child|	
        	      
		      begin

	        	#Rails.logger.info("Google API File: #{child['id']}:#{child['title']}")
		        # Matches current search folder
		        

            if child['mimeType'] == 'application/vnd.google-apps.folder' and recursive
              # Dig down and search sub folders
              sub_results = list_files( child['id'] )
              sub_results.each do |sub_result|
                result << sub_result
              end            

            elsif child.parents[0]['id'] == folder_id or folder_id == 'root' or folder_id.nil?
              result << child
		        end

		    	rescue
		    		Rails.logger.info("File has no parent, continue")
		    	end
	        
  		end	
      
      #Rails.logger.info("Files: #{result}")
    else
      Rails.logger.info("An error occurred from Google API HTTP Error #{api_result.status}: #{api_result.data[:error]}")
    end

    result
	end

	def list_changes(start_change_id=nil)
	    @client ||= api_client()

		result = Array.new
	  	page_token = nil
	 	#begin
   		parameters = {}
   	 	if start_change_id.to_s != ''
      		parameters['startChangeId'] = start_change_id
    	end
	    if page_token.to_s != ''
	      parameters['pageToken'] = page_token
	    end
	    api_result = @client.execute(
	      :api_method => drive.changes.list,
	      :parameters => parameters)

	    if api_result.status == 200
	    	
	    	Rails.logger.info(api_result.data)
	      	return api_result.data
	    else
	      Rails.logger.info("An error occurred: #{result.data['error']['message']}")
	      page_token = nil
	    end
	  	#end while page_token.to_s != ''
	  	result []
	end


	def rename_file(file_id, title)
		@client ||= api_client()
	  	# @drive = client.discovered_api('drive', 'v2')
	  	result = @client.execute(
	    	:api_method => @drive.files.patch,
	    	:body_object => { 'title' => title },
	    	:parameters => { 'fileId' => file_id })
	  	if result.status == 200
	    	return result.data
	  	end
	  		Rails.logger.info("An error occurred: #{result.data['error']['message']}")
	  	return nil
	end

	def insert_file(title, description, parent_id, mime_type, file_name=nil)
	   @client ||= api_client()

	   file = @drive.files.insert.request_schema.new({
	     'title' => title,
	     'description' => description,
	     'mimeType' => mime_type
	   })

	   # Set the parent folder.
	   if parent_id
	     file.parents = [{'id' => parent_id}]
	   end

	   if !file_name.nil?
	      media = Google::APIClient::UploadIO.new(file_name, mime_type)
	   else
	      media = ''
	   end 

	   result = @client.execute(
	     :api_method => @drive.files.insert,
	     :body_object => file,
	     :parameters => {
	       # 'uploadType' => 'multipart',
	       # 'alt' => 'json'}
	     })
	   if result.status == 200
	     return result.data
	   else
	     Rails.logger.info("An error occurred: #{result.data['error']['message']}")
	     return nil
	   end
	end

	def trash_file(file_id)
		@client ||= api_client()

		if file_id.nil?
			Rails.logger.info("File id is nil. WTF man?")
			return false
		end

	  	result = @client.execute(
	    	:api_method => @drive.files.trash,
	    	:parameters => { 'fileId' => file_id })
	  	if result.status == 200
	    	return result.data
	  	else
	    	Rails.logger.info("An error occurred: #{result.inspect}")
	  	end
	end


	# Permanently delete a file from Google Drive
	# Do not use, use trash instead 
	def remove_file(file_id)
		@client ||= api_client()

		if file_id.nil?
			Rails.logger.info("File id is nil. WTF man?")
			return false
		end

	  	result = @client.execute(
	    	:api_method => @drive.files.delete,
	    	:parameters => { 'fileId' => file_id }
    	)

	  	if result.status != 200 or result.status != 204
	    	Rails.logger.info("An error occurred: #{result.inspect}")
	    	return false
	  	end

	  	return true
	end

	
end
