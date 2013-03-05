require 'yaml'
require 'nokogiri'


namespace :admin  do
  desc "Update the types of all the Resources."
  task :standards_xml_to_csv, [:xml_file, :csv_file] => [:environment] do |t, args|

    print "Reading xml file: #{args[:xml_file]}\n"
    print "Writing yaml file: #{args[:csv_file]}\n"

    file_stream = File.open(args[:xml_file])
    xml_doc = Nokogiri::XML(file_stream)

    standards = []

    subject = CourseSubject.find_by_name 'English'
    sub_subject = 'English Language Arts and Literacy'

    standards << "StatementCode|Grade|Subject|Sub-Subject|Statement\n"

    parent_standards = {}
    parent_standard = nil

    standard_count = {}
    course_grades = []
    xml_doc.search('LearningStandardItem').each do |t|
      
      name = t.at('StatementCode').inner_text

      standard_count[name] = true

      if name == nil or name.empty?
        next
      end

      description = ActionView::Base.full_sanitizer.sanitize(t.at('Statement').inner_text)
      description = description.gsub(/\r/,'')
      description = description.gsub(/\n/,'')

      t.search('GradeLevel').each do |grade_elem|
        # CC ELA&L has 11-12 as grade level
        grade = grade_elem.inner_text
        if grade =~ /-/
          grade.split('-').collect do |grade_name|
           # standards << "#{name}|#{grade_name}|#{subject.name}|#{sub_subject}|#{description}\n"
            course_grades << grade_name
          end
        else
          grade_name = (grade != 'K') ? grade.to_i.to_s : grade
          #standards << "#{name}|#{grade_name}|#{subject.name}|#{sub_subject}|#{description}\n"
          course_grades << grade_name
        end
      end


      standards << "#{name}|#{course_grades.join(", ")}|#{subject.name}|#{sub_subject}|#{description}\n"
      course_grades = []
      
    end

    print "Number of standards with unique name: #{standard_count.length}\n"

    file_stream.close

    begin
      file = File.open(args[:csv_file], 'w')
      standards.each do |s|
        file.write(s) 
      end
    rescue IOError => e
      #some error occur, dir not writable etc.
    ensure
      file.close unless file == nil
    end

    print "Have a nice day #{ENV['USER']}\n"
  end
end

