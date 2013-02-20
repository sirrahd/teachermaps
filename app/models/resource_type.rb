class ResourceType < ActiveRecord::Base

	attr_accessible :name, :thumbnail
	

	MIME_TYPE_CONVERSION = {
		'text/link' => 'Web',

	    'text/html' => 'Document',
	    'text/plain'=> 'Document',
	    'application/rtf'=> 'Document',
	    'application/txt'=> 'Document',
	    'application/vnd.oasis.opendocument.text'=> 'Document',
	    'application/pdf'=> 'Document',
	    'application/msword' => 'Document',
	    'application/vnd.openxmlformats-officedocument.wordprocessingml.document' => 'Document',
	    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' => 'Document',
	    'application/x-vnd.oasis.opendocument.spreadsheet' => 'Document',
	    'text/csv' => 'Document',
	    'application/atom+xml' => 'Document',
	    'application/vnd.ms-excel' => 'Document',
	    'application/vnd.ms-excel.sheet.binary.macroenabled.12' => 'Document',
	    'application/vnd.ms-excel.template.macroenabled.12' => 'Document',
	    'application/vnd.ms-excel.sheet.macroenabled.12' => 'Document',
	    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' => 'Document',
	    'application/vnd.openxmlformats-officedocument.spreadsheetml.template' => 'Document',
	    'application/vnd.openxmlformats-officedocument.wordprocessingml.document' => 'Document',
	    'application/vnd.openxmlformats-officedocument.wordprocessingml.template' => 'Document',
	    'application/x-mswrite' => 'Document',
	    'application/vnd.oasis.opendocument.text' => 'Document',
	    'text/richtext' => 'Document',
	    'application/xml' => 'Document',
	    'application/vnd.oasis.opendocument.presentation' => 'Document',

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
	    'application/vnd.oasis.opendocument.spreadsheet' => 'Presentation',
	    

	    'image/jpeg'=> 'Image',
	    'image/gif'=> 'Image',
	    'image/png'=> 'Image',
	    'image/svg+xml'=> 'Image',
	    'image/bmp' => 'Image',
	    'image/x-icon' => 'Image',


	    'audio/ogg' => 'Audio',
	    'audio/mp4' => 'Audio',
	    'audio/x-ms-wma' => 'Audio',
	    'audio/x-mpegurl' => 'Audio',
	    'audio/x-aac' => 'Audio',    

	
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
	    'video/ogg' => 'Video'
    
	}
  
end
