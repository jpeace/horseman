%w(io open_uri).each do |patch|
	require_relative "patches/#{patch}"
end