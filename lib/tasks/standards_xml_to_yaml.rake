require 'yaml'
require 'nokogiri'

namespace :admin  do
  desc "Update the types of all the Resources."
  task :standards_xml_to_yaml, :xml_file, :yaml_file do |t, args|

    print "Reading xml file: #{args[:xml_file]}\n"
    print "Writing yaml file: #{args[:yaml_file]}\n"

    file_stream = File.open(args[:xml_file])
    xml_doc = Nokogiri::XML(file_stream)

    xml_doc.search('//LearningStandardItem').each do |t|
      name = t.at('StatementCode').inner_text
      description = t.at('Statement').inner_text

      t.search('//GradeLevels').each do |element|

        grade = element.at('GradeLevel').inner_text
        print "#{name} #{grade} #{description}\n"

      end

      
      print "#{t.at('StatementCode').inner_text}\n"
    end

    file_stream.close

    print "Have a nice day #{ENV['USER']}\n"
  end
end