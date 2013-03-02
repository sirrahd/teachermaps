require 'yaml'
require 'nokogiri'

namespace :admin  do
  desc "Update the types of all the Resources."
  task :standards_xml_to_yaml, [:xml_file, :yaml_file] => [:environment] do |t, args|

    print "Reading xml file: #{args[:xml_file]}\n"
    print "Writing yaml file: #{args[:yaml_file]}\n"

    file_stream = File.open(args[:xml_file])
    xml_doc = Nokogiri::XML(file_stream)

    standards = []
    standard = nil


    subject = CourseSubject.find_by_name 'English'
    sub_subject = 'English Language Arts and Literacy'

    xml_doc.search('LearningStandardItem').each do |t|
      

      name = t.at('StatementCode').inner_text
      description = ActionView::Base.full_sanitizer.sanitize(t.at('Statement').inner_text)

      t.search('GradeLevels').each do |element|

        grade = element.at('GradeLevel').inner_text
        grade = (grade != 'K') ? grade.to_i.to_s : grade
        grade = CourseGrade.find_by_name grade
        #print "#{name} #{grade.id} #{description}\n"

        standard = Standard.new
        standard.name = name
        standard.text = description
        standard.course_grade = grade
        standard.course_subject = subject
        standard.sub_subject = sub_subject

      end
    end

    file_stream.close


    print "Have a nice day #{ENV['USER']}\n"
  end
end