require 'google/api_client'

module GoogleAccountsHelper

	attr_accessor :google_documents, :google_authorization_uri, :google_session

	# Returns cached documents
	def google_documents
		@documents ||= Array.new
		@documents
	end

	# Generates Ouath URL Request
	def google_authorization_uri
		@client ||= google_client()
		@client.authorization.authorization_uri.to_s
	end 

	# Returns authorized tokens
	def google_session
		@client ||= google_client()
		@client.authorization
	end 

	# Loads Google API client with persisted OAuth data
	def google_load_session(account)
		@client ||= google_client()
		@client.authorization.access_token  = account.access_token
	    @client.authorization.refresh_token = account.refresh_token
	    @client.authorization.expires_in    = account.expires_in
	    @client.authorization.issued_at     = account.issued_at
	end
	

	# Gets/Updates OAuth tokens needed for Google API
	def google_refresh_token (auth_code)

		@client ||= google_client()


	    @client.authorization.code = auth_code
	    @client.authorization.fetch_access_token!
	end

	def google_fetch_documents( folder_id=nil )

		@documents = (begin
			drive = @client.discovered_api('drive', 'v2')

		    result = Array.new
		    parameters = {}

		    parameters['title'] = 'TeacherMaps'
		    parameters['maxResults'] = '10'

		    if !folder_id.nil?
		       # Only look in this folder
		   	   parameters['parents'] = [folder_id]
		    end
		 

		    api_result = @client.execute(
		      :api_method => drive.files.list,
		      :parameters => parameters)

		    if api_result.status == 200
		      children = api_result.data
		      children.items.each do |child|	
		        	      
		        begin
			        # If resource id matches TeacherMaps folder id
			        if child.parents[0]['id'] == folder_id
			        	result << child
			        end
		    	rescue
		    		Rails.logger.info("Error in querying Google Drive.")
		    		return result
		    	end
		        
		      end
		      
		      Rails.logger.info("Files: #{result}")
		    else
		      Rails.logger.info("An error occurred from Google API HTTP Error #{api_result.status}: #{api_result.data[:error]}")
		    end

		    result
		end)
	end


	# Typical binary data file, Non-Google Document
	def create_file(client, title, description, parent_id, mime_type, file_name)
	   insert_file(client, title, description, parent_id, 'application/vnd.google-apps.file', file_name)
	end

	# Google Document
	def create_google_document(client, title, description, parent_id, mime_type, file_name)
	   insert_file(client, title, description, parent_id, 'application/vnd.google-apps.document', file_name)
	end

	# Google Folder
	def create_folder(title, description, parent_id=nil)
	   @client ||= google_client()
	   insert_file(@client, title, description, parent_id, 'application/vnd.google-apps.folder')
	end

	# Photo file
	def create_image(client, title, description, parent_id, mime_type, file_name)
	   insert_file(client, title, description, parent_id, 'application/vnd.google-apps.photo', file_name)
	end

	# Video file
	def create_image(client, title, description, parent_id, mime_type, file_name)
	   insert_file(client, title, description, parent_id, 'application/vnd.google-apps.video', file_name)
	end


	def google_create_teachermaps_folder()
		app_folder = create_folder("Apps", "Store and Organize all your teaching materials");
	    Rails.logger.info("Apps Folder: #{app_folder['mimeType']}")
	    teachermaps_folder = create_folder("TeacherMaps", "Store and Organize all your teaching materials", app_folder['id']);
	    Rails.logger.info("TeacherMaps Folder: #{teachermaps_folder['mimeType']}")
	    teachermaps_folder['id']
	end

	private 

	def google_client()
		@client ||= (begin
			client = Google::APIClient.new

			client.authorization.client_secret = Rails.application.config.CLIENT_SECRET
			client.authorization.redirect_uri  = Rails.application.config.REDIRECT_URI
			client.authorization.client_id     = Rails.application.config.CLIENT_ID
			client.authorization.scope         = Rails.application.config.SCOPES

			client
		end)
	end

	def insert_file(client, title, description, parent_id, mime_type, file_name=nil)
	   drive = client.discovered_api('drive', 'v2')
	  
	   file = drive.files.insert.request_schema.new({
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
	   result = client.execute(
	     :api_method => drive.files.insert,
	     :body_object => file,
	     :parameters => {
	       # 'uploadType' => 'multipart',
	       # 'alt' => 'json'}
	     })
	   if result.status == 200
	     return result.data
	   else
	     puts "An error occurred: #{result.data['error']['message']}"
	     return nil
	   end
	end






end
