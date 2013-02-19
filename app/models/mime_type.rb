class MimeType < ActiveRecord::Base

   TYPES = {
    'text/html' => 'HTML',
    'text/link' => 'Web',
    'text/plain'=> 'Text',
    'application/rtf'=> 'Text',
    'application/vnd.oasis.opendocument.text'=> 'Word Document',
    'application/pdf'=> 'PDF',
    'application/msword' => 'Word Document',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document' => 'Word Document',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' => 'Spreadsheet',
    'application/x-vnd.oasis.opendocument.spreadsheet' => 'Spreadsheet',
    'image/jpeg'=> 'Image',
    'image/gif'=> 'Image',
    'image/png'=> 'Image',
    'image/svg+xml'=> 'Image',
    'application/vnd.openxmlformats-officedocument.presentationml.presentation' => 'Presentation'
  }


  
  # attr_accessible :title, :body
  attr_accessible :name, :mime_type, :thumb_nail
end
