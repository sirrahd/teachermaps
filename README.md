# TeacherMaps

TeacherMaps makes lesson planning easier by helping teachers collect their digital resources in one place, organize them into standard-aligned units called maps, and share them with other educators. TeacherMaps syncs with Dropbox and Google drive to make managing and sharing all types of resources, from worksheets to web links, simple.

This minimum viable product was built by by Evan Moore, James Kobol, and Andrew Harris during the Spring of 2013. The live service is available at [teachermaps.com](http://www.teachermaps.com). We are not actively working on the project at this time, but we still take support requests and will take pull requests. If you're interested in using or contributing to the service, we're happy to help.

## Installing

TeacherMaps is a fairly standard Ruby on Rails application based on Ruby 1.9.* and Rails 3.2.*. Once you've installed Ruby 1.9.3 and bundler through [rvm](http://rvm.io/) or other means, a simple `bundle install` in the TeacherMaps root directory will install all dependencies. You may also need to install a JavaScript Runtime like NodeJS.

## Configuring

Create a copy of the file without `.sample` and follow the instructions that start with `TODO:` in the files to configure it to your needs.

* `/config/environments/development.rb.sample`
Configuration settings for TeacherMaps in local environments.

* `/config/environments/production.rb.sample`
Configuration settings for TeacherMaps in production environments.

* `/config/initializers/secret_token.rb.sample`
If you plan to publish some form of this application, you should provide a unique secret token for security reasons.

## Creating and populating the databases

First, you'll want to create a local TeacherMaps database.

	rake db:create
	rake db:migrate

TeacherMaps also includes common core standards for Math and English, which you can optionally add to the the database.

	rake db:seed

## Running

Type `rails server` to serve TeacherMaps at `http://localhost:3000`.
