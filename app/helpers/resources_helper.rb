module ResourcesHelper

	def save_file(upload)
		begin
			#name =  File.basename(upload['datafile'].original_filename)
		    directory = "public/data"
		    # create the file path
		    path = File.join(directory, SecureRandom.urlsafe_base64 )
		    # write the file
		    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
		    path
		rescue
			false
		end
	end

end