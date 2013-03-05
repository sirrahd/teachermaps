require 'yaml'


# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create the seed data 



# Course Grades 
seed = YAML::load_file('db/seeds/course_grades.yaml')
seed.each do |key, grade|  
	CourseGrade.find_or_create_by_name grade['name']
end  



# Course Subjects
seed = YAML::load_file('db/seeds/course_subjects.yaml')
seed.each do |key, subject|
	CourseSubject.find_or_create_by_name subject['name']
end  



# Resource Types
seed = YAML::load_file('db/seeds/resource_types.yaml')
seed.each_pair do |key,resource_type|  
	resource_type_object = ResourceType.find_or_create_by_name resource_type['name']
	# Update thumbnails
	resource_type_object.thumbnail = resource_type['thumbnail']
	resource_type_object.save
end  


if ActiveRecord::Base.connection.table_exists? 'standard_types'
	# Standard Types
	seed = YAML::load_file('db/seeds/standard_types.yaml')
	seed.each_pair do |key,standard_type|  
		standard_type_object = StandardType.find_or_create_by_name standard_type['name']
	end  
end

if ActiveRecord::Base.connection.table_exists? 'standards'
	# ELA E Standards
	seed = YAML::load_file('db/seeds/cc-ela-lit.yaml')
	seed.each_pair do |key,standard|  
		
		s = Standard.find_or_create_by_name standard['name']
		s.name = standard['name']
		s.text = standard['text']
		s.course_grades << CourseGrade.find_by_name( standard['course_grade'] )
		s.course_subject = CourseSubject.find_by_name standard['course_subject']
		s.sub_subject = standard['sub_subject']
		s.is_parent_standard = standard['is_parent_standard']
		
		if standard['parent_standard']
			s.parent_standard = Standard.find_by_name standard['parent_standard']
		end

		s.save
		print "Created #{standard['name']}\n"
	end  
end














