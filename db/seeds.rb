# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create the seed data 



# Course Grades 
seed = [
	'K', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10',
	'10', '11', '12'
]
seed.each do |name|  
	CourseGrade.find_or_create_by_name name
end  



# Course Subjects
seed = [
	'Mathematics', 'Physics', 'Science', 'History', 'Social Studies', 'Foreign Languages'
]
seed.each do |name|  
	CourseSubject.find_or_create_by_name name
end  