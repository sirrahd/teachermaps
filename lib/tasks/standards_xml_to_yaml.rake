require 'yaml'
require 'nokogiri'

namespace :admin  do
  desc "Update the types of all the Resources."
  task :standards_xml_to_yaml, :xml_file do |t, xml_file|

    print "Reading xml file: #{xml_file}\n"



    reader = Nokogiri::XML::Reader(xml_file)
    titles = []
    text = ''
    grab_text = false
    reader.each do |elem|
      if elem.name == "title"
        if elem.node_type == 1  # start element?
          grab_text = true
        else # elem.node_type == 15  # end element?
          titles << text
          text = ''
          grab_text = false
        end
      elsif grab_text && elem.node_type == 3 # text?
        print elem.value
      end
    end
  	

    print "Have a nice day #{ENV['USER']}\n"
  end
end