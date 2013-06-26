class AddPrivacyStateToMaps < ActiveRecord::Migration
  def self.up
    add_column :maps, :privacy_state, :integer, :default => PrivacyState::PRIVATE

    # Update previous maps
    Map.all.each do |map|
    	map.privacy_state = PrivacyState::PRIVATE
    	map.save
    end

  end

  def self.down
    remove_column :maps, :privacy_state
  end
end
