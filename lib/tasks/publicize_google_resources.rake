
namespace :admin  do
  desc "Make all the Google Resource world readable."
  task :publicize_google_resources => :environment do

    users = User.all
    users.each do |user|
    	
    	unless user.has_google_account?
    		# Skip if user has no google account
    		next
  		end

  		# Filter only Google resources
    	resources = user.resources.select { |resource| resource.class.name == GoogleResource::TYPE }
	    resources.each do |resource|
	    	
	    	# Update the permission
	    	user.google_account.enable_world_readable(resource.file_id)
	    	print "Resource now world readable: #{resource.title}\n"
    		
	    end
    end
    print "Have a nice day #{ENV['USER']}\n"
  end
end