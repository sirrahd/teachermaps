require 'google/api_client'

module GoogleApisHelper


	attr_accessor :google_documents, :google_authorization_uri, :google_session

	# def initialize
	# 	@client = client()
	# 	@documents = Array.new
	# end     

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

	def google_load_session(session)
		@client ||= google_client()
		@client.authorization.access_token  = session[:access_token]
	    @client.authorization.refresh_token = session[:refresh_token]
	    @client.authorization.expires_in    = session[:expires_in]
	    @client.authorization.issued_at     = session[:issued_at]
	end
	

	def google_refresh_token (auth_code)

		@client ||= google_client()

	
		# Rails.logger.info("Google Auth Code: #{auth_code}")  
	    @client.authorization.code = auth_code
	    @client.authorization.fetch_access_token!
		
	  
	end

	def google_fetch_documents

		@documents = (begin
			drive = @client.discovered_api('drive', 'v2')

		    result = Array.new
		    
		    api_result = @client.execute(
		      :api_method => drive.files.list
		    )

		    if api_result.status == 200
		      files = api_result.data
		      result.concat(files.items)
		    else
		      Rails.logger.info("An error occurred pulling data from Google API HTTP Error #{api_result.status}")
		    end

		    result
		end)
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


end
