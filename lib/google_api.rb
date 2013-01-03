require 'google/api_client'

class GoogleApi
	
	def get_client
		@client ||= (begin
			client = Google::APIClient.new

			client.authorization.client_id = Rails.application.config.CLIENT_ID
			client.authorization.client_secret = Rails.application.config.CLIENT_SECRET
			client.authorization.redirect_uri = Rails.application.config.REDIRECT_URI
			client.authorization.scope = Rails.application.config.SCOPES
			client
		end)
	end
end
