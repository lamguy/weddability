class RobotsGenerator
	# Use the config/robots.text in production.
	# Disallow everything for all other environments.

	def self.call(env)
		body = if Rails.env.production?
			File.read Rails.root.join('config', 'robots.txt')
		else
			"User-agent: *\nDisallow: /"
		end

	    headers = { 'Cache-Control' => "public, max-age=#{1.year.seconds.to_i}" }

	    [200, headers, [body]]
	  rescue Errno::ENOENT
	    [404, {}, ['# A robots.txt is not configured']]
	end
end