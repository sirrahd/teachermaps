class ResourceType < ActiveRecord::Base

	attr_accessible :name, :thumbnail


	MIME_TYPE_CONVERSIONS = {
		'text/link' => 'Web',

	    'text/html' => 'Document',
	    'text/plain'=> 'Document',
	    'application/rtf'=> 'Document',
	    'application/txt'=> 'Document',
	    'application/vnd.oasis.opendocument.text'=> 'Document',
	    'application/pdf'=> 'Document',
	    'application/msword' => 'Document',	    
	    'text/csv' => 'Document',
	    'application/atom+xml' => 'Document',
	    'application/vnd.openxmlformats-officedocument.wordprocessingml.document' => 'Document',
	    'application/vnd.openxmlformats-officedocument.wordprocessingml.template' => 'Document',
	    'application/vnd.google-apps.document' => 'Document',
	    'application/x-mswrite' => 'Document',
	    'text/richtext' => 'Document',
	    'application/xml' => 'Document',

	    
	    'application/vnd.oasis.opendocument.presentation' => 'Presentation',
	    'application/vnd.openxmlformats-officedocument.presentationml.presentation' => 'Presentation',
	    'application/vnd.openxmlformats-officedocument.presentationml.presentation' => 'Presentation',
	    'application/vnd.openxmlformats-officedocument.presentationml.slide' => 'Presentation',
	    'application/vnd.openxmlformats-officedocument.presentationml.slideshow' => 'Presentation',
	    'application/vnd.openxmlformats-officedocument.presentationml.template' => 'Presentation',
	    'application/vnd.ms-powerpoint' => 'Presentation',
	    'application/vnd.ms-powerpoint.addin.macroenabled.12' => 'Presentation',
	    'application/vnd.ms-powerpoint.slide.macroenabled.12' => 'Presentation',
	    'application/vnd.ms-powerpoint.slideshow.macroenabled.12' => 'Presentation',
	    'application/vnd.ms-powerpoint.presentation.macroenabled.12' => 'Presentation',
	    'application/vnd.google-apps.presentation' => 'Presentation',
	    

	    'application/vnd.oasis.opendocument.spreadsheet' => 'Spreadsheet',
	    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' => 'Spreadsheet',
	    'application/x-vnd.oasis.opendocument.spreadsheet' => 'Spreadsheet',
	    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' => 'Spreadsheet',
	    'application/vnd.openxmlformats-officedocument.spreadsheetml.template' => 'Spreadsheet',
	    'application/vnd.google-apps.spreadsheet' => 'Spreadsheet',
	    'application/vnd.ms-excel' => 'Spreadsheet',
	    'application/vnd.ms-excel.sheet.binary.macroenabled.12' => 'Spreadsheet',
	    'application/vnd.ms-excel.template.macroenabled.12' => 'Spreadsheet',
	    'application/vnd.ms-excel.sheet.macroenabled.12' => 'Spreadsheet',
	    
	    

	    'image/jpeg'=> 'Image',
	    'image/gif'=> 'Image',
	    'image/png'=> 'Image',
	    'image/svg+xml'=> 'Image',
	    'image/bmp' => 'Image',
	    'image/x-icon' => 'Image',
	    'application/vnd.google-apps.drawing' => 'Image',
	    'application/vnd.google-apps.photo' => 'Image',


	    'audio/mpeg' => 'Audio',
	    'audio/ogg' => 'Audio',
	    'audio/mp4' => 'Audio',
	    'audio/x-ms-wma' => 'Audio',
	    'audio/x-mpegurl' => 'Audio',
	    'audio/x-aac' => 'Audio',    
	    'application/vnd.google-apps.audio' => 'Audio',
	    'audio/x-wav' => 'Audio',
	    'audio/wav' => 'Audio',
	    'audio/mid' => 'Audio',
	    'audio/x-mpegurl' => 'Audio',

	
	    'application/x-shockwave-flash' => 'Video',
	    'video/x-msvideo' => 'Video',
	    'video/x-flv' => 'Video',
	    'video/h261' => 'Video',
	    'video/h263' => 'Video',
	    'video/h264' => 'Video',
	    'video/jpeg' => 'Video',
	    'video/x-m4v' => 'Video',
	    'video/x-ms-wm' => 'Video',
	    'video/x-ms-wmv' => 'Video',
	    'video/mpeg' => 'Video',
	    'video/mp4' => 'Video',
	    'application/mp4' => 'Video',
	    'video/ogg' => 'Video',
	    'application/vnd.google-apps.video' => 'Video'

	}
  
end
