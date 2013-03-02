require 'yaml'
require 'csv'
require 'digest/md5'


namespace :admin  do
  desc "Update the types of all the Resources."
  task :standards_csv_to_yaml, [:csv_file, :yaml_file] => [:environment] do |t, args|

    print "Reading xml file: #{args[:csv_file]}\n"
    print "Writing yaml file: #{args[:yaml_file]}\n"

    standards = {}


    yaml_data = []
    standard_num = 0    
    CSV.foreach(args[:csv_file], :col_sep => ',') do |standard_row|

      standard = {}
      standard['slug'] = Base64::encode64("#{Time.now.to_s} #{standard_num}")
      standard['slug'] = "#{standard['slug']}"
      standard['name'] = standard_row[0]
      standard['course_grade'] = standard_row[3]
      standard['course_subject'] = standard_row[4]
      standard['sub_subject'] = standard_row[5]
      standard['is_parent_standard'] = (standard_row[2] == 'TRUE') ? true : false
      standard['parent_standard'] = standard_row[1]

      text = standard_row[6].gsub "\t", ''
      text = text.delete "!", ''
      standard['text'] = text

      print "#{standard['slug']}\n"

      key = "standard_#{standard_num}"
      standards[key] = standard
      standard_num += 1



      #yaml_data << "standard_#{slug}:\n"

    
    end

    print "#{standards.length}"
    File.open(args[:yaml_file], 'w') do |f|
      f.write(standards.to_yaml)
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