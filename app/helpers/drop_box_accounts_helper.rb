module DropBoxAccountsHelper

	ACCESS_TYPE = Rails.application.config.ACCESS_TYPE

	

	def list_folder(drop_box_account)
		@client ||= drop_box_client( drop_box_account )
	    

	    unless @client
	        return nil
	    end

	    
	    path =  '/'
	    begin
	        entry = @client.metadata(path)
	    rescue DropboxAuthError => e
	        session.delete(:authorized_db_session)  # An auth error means the db_session is probably bad
	    rescue DropboxError => e
	        Rails.logger.info("DropBox Error")  
	    end

	    entry['contents'].each do |child|
	      	cp = child['path']
	        Rails.logger.info("DropBox File #{cp}")  
	    end

	    return entry



	end

	def request_drop_box_session()
		db_session = DropboxSession.new(APP_KEY, APP_SECRET)
	    begin
	       db_session.get_request_token
	       store = {}
		   store['request_db_session'] = db_session.serialize

		   # Need to get rid of hard coded url
		   store['auth_url'] = db_session.get_authorize_url 'http://localhost:3000/dropbox/oauth_callback'
		   store
	    rescue DropboxError => e
	       Rails.logger.info("Oh..no.. DropBox session request broke")   
	       {'request_db_session' => nil, 'auth_url' => nil }
	    end
	end 

	def render_folder(db_client, entry)

		out = ''
	    # # Provide an upload form (so the user can add files to this folder)
	    # out = "<form action='/upload' method='post' enctype='multipart/form-data'>"
	    # out += "<label for='file'>Upload file:</label> <input name='file' type='file'/>"
	    # out += "<input type='submit' value='Upload'/>"
	    # out += "<input name='folder' type='hidden' value='#{h entry['path']}'/>"
	    # out += "</form>"  # TODO: Add a token to counter CSRF attacks.

	    # List of folder contents
	    entry['contents'].each do |child|
	        cp = child['path']      # child path
	        cn = File.basename(cp)  # child name
	        if (child['is_dir']) then cn += '/' end
	        out += "<div><a style='text-decoration: none' href='/?path=#{cp}'>#{cn}</a></div>"
	    end

	    "Folder: #{entry['path']} #{entry}"
	end

	def render_file(drop_box_account, entry)
	    # Just dump out metadata hash
	    "File: #{entry['path']}" + "<pre>#{entry.pretty_inspect}</pre>"
	end


	private 

	# If we already have an authorized DropboxSession, returns a DropboxClient.
	def drop_box_client ( drop_box_account )
	    if drop_box_account.session_token?
	        db_session = DropboxSession.deserialize(drop_box_account.session_token)
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
end
