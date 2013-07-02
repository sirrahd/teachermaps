class PrivacyState < ActiveRecord::Base

	# Database/Querying
	PRIVATE = 0
	PUBLIC  = 1
	
	# For HTML Rendering
	PRIVACY_STATE_CONVERSIONS = {
		'0' => 'PRIVATE',
		'1' => 'PUBLIC'
	}

end
