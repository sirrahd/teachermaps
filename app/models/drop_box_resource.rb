class DropBoxResource < Resource
	attr_accessible :rev, :path, :hash, :modified

	belongs_to :user
end
