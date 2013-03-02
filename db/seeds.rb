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
seed = [
	'K', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'
]
seed.each do |name|  
	CourseGrade.find_or_create_by_name name
end  



# Course Subjects
seed = YAML::load_file('db/seeds/course_subject.yaml')
seed.each do |key, subject|
	CourseSubject.find_or_create_by_name subject['name']
end  



# Resource Types

# seed = {
# 	'Document' => 'icon-font',
# 	'Spreadsheet' => 'icon-th-list',
# 	'Presentation' => 'icon-comment',
# 	'Video' => 'icon-film',
# 	'Audio' => 'icon-music',
# 	'Image' => 'icon-picture',
# 	'Web' => 'icon-globe',
# 	'Other' => 'icon-file',
# }

# seed.each_pair do |name,thumbnail|  
# 	mime_type = ResourceType.find_or_create_by_name name
# 	# Update thumbnails
# 	mime_type.thumbnail = thumbnail
# 	mime_type.save
# end  














