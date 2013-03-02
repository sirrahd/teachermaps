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

    xml_doc.search('LearningStandardItem').each do |t|
      

      name = t.at('StatementCode').inner_text
      description = ActionView::Base.full_sanitizer.sanitize(t.at('Statement').inner_text)

      t.search('GradeLevels').each do |element|

        org_grade = element.at('GradeLevel').inner_text
        grade = element.at('GradeLevel').inner_text
        
        # CC ELA&L has 11-12 as grade level
        if grade =~ /-/
          grade.split('-').collect do |grade_name|
            standards << create_standard(name, description, grade_name)
          end
        else
          grade_name = (grade != 'K') ? grade.to_i.to_s : grade
          standards << create_standard(name, description, grade_name)
        end


      end
    end

    file_stream.close


    standards.each do |s|
      # print "#{s.course_grade.name}\n"
    end

    print "Have a nice day #{ENV['USER']}\n"
  end
end


def create_standard(name, description, grade_name )

  
  grade = CourseGrade.find_by_name grade_name
  subject = CourseSubject.find_by_name 'English'
  sub_subject = 'English Language Arts and Literacy'


  standard = Standard.new
  standard.name = name
  standard.text = description
  standard.course_grade = grade
  standard.course_subject = subject
  standard.sub_subject = sub_subject

  standard
end