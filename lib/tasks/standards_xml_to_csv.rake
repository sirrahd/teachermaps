require 'yaml'
require 'nokogiri'



namespace :admin  do
  
  desc "Update the types of all the Resources."
  task :standards_xml_to_csv, [:xml_file, :csv_file] => [:environment] do |t, args|
    course_grade_map = {
      'K' => 'k', '1' => 'one', '2' => 'two', '3' => 'three', '4' => 'four', '5' => 'five',
      '6' => 'six', '7' => 'seven', '8' => 'eight', '9' => 'nine', '10' => 'ten', 
      '11' => 'eleven', '12' => 'twelve'
    }

    print "Reading xml file: #{args[:xml_file]}\n"
    print "Writing yaml file: #{args[:csv_file]}\n"

    file_stream = File.open(args[:xml_file])
    xml_doc = Nokogiri::XML(file_stream)

    standards = []

    subject = CourseSubject.find_by_name 'Mathematics'
    sub_subject = 'Mathematics'

    standards << "StatementCode|Grade|Subject|Sub-Subject|Statement\n"

    course_grades = []
    xml_doc.search('LearningStandardItem').each do |t|
      
      name = t.at('StatementCode').inner_text

      if name == nil or name.empty?
        next
      end

      description = ActionView::Base.full_sanitizer.sanitize(t.at('Statement').inner_text)
      description = description.gsub(/\r/,'')
      description = description.gsub(/\n/,'')

      t.search('GradeLevel').each do |grade_elem|
        grade = grade_elem.inner_text
        # CC ELA&L has 11-12 as grade level
        if grade =~ /-/
          grade.split('-').collect do |grade_name|
            course_grades << course_grade_map[grade_name]
          end
        else
          grade_name = (grade != 'K') ? grade.to_i.to_s : grade
          course_grades << course_grade_map[grade_name]
        end
      end

      standards << "#{name}|#{course_grades.join(", ")}|#{subject.name}|#{sub_subject}|#{description}\n"
      course_grades = []

    end

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

