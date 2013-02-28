

namespace :admin  do
  desc "Update the types of all the Resources."
  task :update_resource_types => :environment do
  	# Loads the resource types before starting work
    load "#{Rails.root}/db/seeds.rb"

    print "Updating the types of all Resources.\n"
    resources = Resource.all
    resources.each do |resource|
      resource.assign_type()
    end
    print "Have a nice day #{ENV['USER']}\n"
  end
end