# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# User.create( name: "James Kobol", email: "jim.kobol@gmail.com", account_name: "jameskobol", password: 'jameskobol', password_confirmation: 'jameskobol')

CourseGrade.delete_all
CourseGrade.create(:name => 'K')
CourseGrade.create(:name => '1')
CourseGrade.create(:name => '2')
CourseGrade.create(:name => '3')
CourseGrade.create(:name => '4')
CourseGrade.create(:name => '5')
CourseGrade.create(:name => '6')
CourseGrade.create(:name => '7')
CourseGrade.create(:name => '8')
CourseGrade.create(:name => '9')
CourseGrade.create(:name => '10')
CourseGrade.create(:name => '11')
CourseGrade.create(:name => '12')


CourseSubject.delete_all
CourseSubject.create(:name => 'Mathematics')
CourseSubject.create(:name => 'Physics')
CourseSubject.create(:name => 'Science')
CourseSubject.create(:name => 'History')
CourseSubject.create(:name => 'Social Studies')
CourseSubject.create(:name => 'Foreign Languages')
