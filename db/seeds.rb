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
	print "#{grade['name']}\n"
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














