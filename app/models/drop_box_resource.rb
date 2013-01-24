class DropBoxResource < Resource
	include Rails.application.routes.url_helpers


	attr_accessible :rev, :path

	belongs_to :user

	def open_link
		# TODO, use drop_box_accounts_preview_url instead of hardcoding the path
		"/dropbox/preview#{self.path}"
		# url = drop_box_accounts_preview_url+"#{self.path}"
		# Rails.logger.info("Action: #{url}}")

		# url

	end
end
