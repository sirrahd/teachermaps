class AddCourseSubjectToResources < ActiveRecord::Migration
  def up
  	create_table :table do |t|
     
      t.timestamps
    end
  end

  def down
  	drop_table :table
  end
end
