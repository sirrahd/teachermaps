# require 'google/api_client'

# class GoogleApi

# 	attr_accessor :documents, :authorization_uri, :session

# 	def initialize
# 		@client = client()
# 		@documents = Array.new
# 	end     

# 	def documents
# 		@documents
# 	end

# 	def authorization_uri
# 		@client ||= client()
# 		@client.authorization.authorization_uri.to_s
# 	end 

# 	def session
# 		@client ||= client()
# 		@client.authorization
# 	end 

# 	def load_session(session)
# 		@client.authorization.access_token  = session[:access_token]
# 	    @client.authorization.refresh_token = session[:refresh_token]
# 	    @client.authorization.expires_in    = session[:expires_in]
# 	    @client.authorization.issued_at     = session[:issued_at]
# 	end
	

# 	def refresh_token (auth_code)

# 		@client ||= client()

	
# 		# Rails.logger.info("Google Auth Code: #{auth_code}")  
# 	    @client.authorization.code = auth_code
# 	    @client.authorization.fetch_access_token!
		
	  
# 	end

# 	def fetch_documents

# 		@documents = (begin
# 			drive = @client.discovered_api('drive', 'v2')

# 		    result = Array.new
		    
# 		    api_result = @client.execute(
# 		      :api_method => drive.files.list
# 		    )

# 		    if api_result.status == 200
# 		      files = api_result.data
# 		      result.concat(files.items)
# 		    else
# 		      Rails.logger.info("An error occurred pulling data from Google API HTTP Error #{api_result.status}")
# 		    end

# 		    result
# 		end)
# 	end


# 	def client()
# 		@client ||= (begin
# 			client = Google::APIClient.new

# 			client.authorization.client_secret = Rails.application.config.CLIENT_SECRET
# 			client.authorization.redirect_uri  = Rails.application.config.REDIRECT_URI
# 			client.authorization.client_id     = Rails.application.config.CLIENT_ID
# 			client.authorization.scope         = Rails.application.config.SCOPES

# 			client
# 		end)
# 	end

# end
