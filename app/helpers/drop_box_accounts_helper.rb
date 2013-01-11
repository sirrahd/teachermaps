module DropBoxAccountsHelper

	ACCESS_TYPE = Rails.application.config.ACCESS_TYPE

	# If we already have an authorized DropboxSession, returns a DropboxClient.
	def get_db_client
	    if session[:authorized_db_session]
	        db_session = DropboxSession.deserialize(session[:authorized_db_session])
	        begin
	            return DropboxClient.new(db_session, ACCESS_TYPE)
	        rescue DropboxAuthError => e
	            # The stored session didn't work.  Fall through and start OAuth.
	            session[:authorized_db_session].delete
	        end
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

	def render_file(db_client, entry)
	    # Just dump out metadata hash
	    "File: #{entry['path']}" + "<pre>#{entry.pretty_inspect}</pre>"
	end
end
