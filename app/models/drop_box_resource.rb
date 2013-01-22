class DropBoxResource < Resource
	attr_accessible :rev, :path, :file_hash, :modified

	belongs_to :user
end
