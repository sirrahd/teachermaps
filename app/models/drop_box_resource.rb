class DropBoxResource < Resource
	attr_accessible :revision, :rev, :path

	belongs_to :user
end
