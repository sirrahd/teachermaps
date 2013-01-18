require 'google/api_client'

module GoogleAccountsHelper

	attr_accessor :google_documents, :google_authorization_uri, :google_session

	def google_documents
		@documents ||= Array.new
		@documents
	end

	def google_authorization_uri
		@client ||= google_client()
		@client.authorization.authorization_uri.to_s
	end 

	def google_session
		@client ||= google_client()
		@client.authorization
	end 

	def google_load_session(account)
		@client ||= google_client()
		@client.authorization.access_token  = account.access_token
	    @client.authorization.refresh_token = account.refresh_token
	    @client.authorization.expires_in    = account.expires_in
	    @client.authorization.issued_at     = account.issued_at
	end
	

	def google_refresh_token (auth_code)

		@client ||= google_client()

	
		# Rails.logger.info("Google Auth Code: #{auth_code}")  
	    @client.authorization.code = auth_code
	    @client.authorization.fetch_access_token!
		
	  
	end

	def google_fetch_documents( folder_id=nil )

		@documents = (begin
			drive = @client.discovered_api('drive', 'v2')

		    result = Array.new
		    parameters = {}

		    if !folder_id.nil?
		       # Only look in this folder
		   	   parameters['parents'] = [folder_id]
		    end
		  

		    parameters['title'] = 'TeacherMaps'
		    parameters['maxResults'] = '10'

		    api_result = @client.execute(
		      :api_method => drive.files.list,
		      :parameters => parameters)

		    if api_result.status == 200
		      children = api_result.data
		      children.items.each do |child|
		        Rails.logger.info("File #{child.title} Parent Id: #{child.parents[0]['id']} #{folder_id}")
		        
		        # If resource id matches TeacherMaps folder id
		        if child.parents[0]['id'] == folder_id
		        	result << child
		        end
		        
		      end
		      
		      Rails.logger.info("Files: #{result}")
		    else
		      Rails.logger.info("An error occurred from Google API HTTP Error #{api_result.status}: #{api_result.data[:error]}")
		    end

		    result
		end)
	end

	def print_files_in_folder(client, folder_id)
	  page_token = nil
	  begin
	    parameters = {'folderId' => folder_id}
	    if page_token.to_s != ''
	      parameters['pageToken'] = page_token
	    end
	    result = client.execute(
	      :api_method => @drive.children.list,
	      :parameters => parameters)
	    if api_result.status == 200
	      children = result.data
	      children.items.each do |child|
	        puts "File Id: #{child.id}"
	      end
	      page_token = children.next_page_token
	    else
	      puts "An error occurred: #{result.data['error']['message']}"
	      page_token = nil
	    end
	  end while page_token.to_s != ''
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
