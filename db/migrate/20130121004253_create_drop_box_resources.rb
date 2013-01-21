class CreateDropBoxResources < ActiveRecord::Migration
  def change
    create_table :drop_box_resources do |t|

      t.string :type
      t.timestamps
    end
  end
end
