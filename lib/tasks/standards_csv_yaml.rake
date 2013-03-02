require 'csv'
require 'digest/sha1'
require 'iconv'

namespace :admin  do
  desc "Update the types of all the Resources."
  task :standards_csv_to_yaml, [:csv_file, :yaml_file] => [:environment] do |t, args|

    print "Reading xml file: #{args[:csv_file]}\n"
    print "Writing yaml file: #{args[:yaml_file]}\n"

    yaml_data = []
    CSV.foreach(args[:csv_file], :col_sep => ',', :headers => true) do |standard|
    
      name = standard[0]
      course_grade = standard[3]
      course_subject = standard[4]
      sub_subject = standard[5]
      is_parent_standard = (standard[2] == 'TRUE') ? true : false
      parent_standard = standard[1]
      text = remove_non_ascii(standard[6]) # Remove unicode values
      slug = Digest::SHA1.hexdigest("#{name} #{text} #{course_grade}").delete "\n"

      yaml_data << "standard_#{slug}:\n"
      yaml_data << " slug: \"#{slug}\"\n"
      yaml_data << " name: \"#{name}\"\n"
      yaml_data << " course_grade: \"#{course_grade}\"\n"
      yaml_data << " course_subject: \"#{course_subject}\"\n"
      yaml_data << " sub_subject: \"#{sub_subject}\"\n"
      yaml_data << " is_parent_standard: \"#{is_parent_standard}\"\n"
      yaml_data << " parent_standard: \"#{parent_standard}\"\n"
      yaml_data << " text: \"#{text}\"\n"
    end

    print "Lines of YAML #{yaml_data.length}\n"
    File.open(args[:yaml_file], 'w') do |f|
      yaml_data.each do |standard|
        f.write(standard)
      end
    end

    print "Have a nice day #{ENV['USER']}\n"
  end
end

def remove_non_ascii (string)
  Iconv.conv('ASCII//IGNORE', 'UTF8', string)
end