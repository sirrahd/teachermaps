class DeleteUnusedStandardMetadata < ActiveRecord::Migration
  def up
    
    # Remove CA Content Standards
    standard = StandardType.find_by_name 'California Content Standards'
    standard.delete if standard

  end

  def down
  end
end
