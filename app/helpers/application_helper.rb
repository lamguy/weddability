module ApplicationHelper
	def javascript(*file)
		content_for(:head) { javascript_include_tag(*file) }
	end
end
