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

counter = 0
if ActiveRecord::Base.connection.table_exists? 'standards'
	[
		'db/seeds/ccss.ela-literacy.yaml',
		'db/seeds/ccss.mathematics.yaml'
	].each do |file|

		print "Loading standards #{file}\n"
		seed = YAML::load_file(file)
		seed.each_pair do |key,standard|  
			
			counter += 1

			s = Standard.find_or_create_by_slug standard['slug']
			s.slug = standard['slug']
			s.name = standard['name']
			s.text = standard['text']
			s.course_subject = CourseSubject.find_by_name standard['course_subject']
			s.standard_type = StandardType.find_by_name standard['standard_type']
			s.sub_subject = standard['sub_subject']
			s.is_parent_standard = standard['is_parent_standard']

			# print "Found #{standard['course_grades']}\n"
			standard_grades = standard['course_grades'].delete(' ').split(",")
			standard_grades.each do |grade_name|
				
				g = CourseGrade.find_by_name(grade_name)
				if not s.course_grades.include? g
					print "Adding #{g.name} to standard #{s.name}\n"
					s.course_grades << g
				end

			end

			if standard['parent_standard']
				# Parent/Child relationship
				s.parent_standard = Standard.find_by_name standard['parent_standard']
			end

			s.save
			# print "Created/Updated #{standard['name']}\n"
		end 
	end 
end
# print "Count: #{counter}\n"














