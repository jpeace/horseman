# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "horseman"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jarrod Peace"]
  s.date = "2012-01-09"
  s.description = "Headless HTTP crawler/scraper"
  s.email = "peace.jarrod@gmail.com"
  s.extra_rdoc_files = ["README.rdoc", "lib/horseman.rb", "lib/horseman/browser.rb", "lib/horseman/connection.rb", "lib/horseman/cookies.rb", "lib/horseman/hidden_fields.rb", "lib/horseman/response.rb", "lib/horseman/version.rb"]
  s.files = ["Gemfile", "Gemfile.lock", "Manifest", "README.rdoc", "Rakefile", "horseman.gemspec", "lib/horseman.rb", "lib/horseman/browser.rb", "lib/horseman/connection.rb", "lib/horseman/cookies.rb", "lib/horseman/hidden_fields.rb", "lib/horseman/response.rb", "lib/horseman/version.rb", "spec/horseman/browser_spec.rb", "spec/horseman/connection_spec.rb", "spec/horseman/cookies_spec.rb", "spec/horseman/hidden_fields_spec.rb", "spec/horseman/response_spec.rb", "spec/mocks.rb", "spec/spec_helper.rb"]
  s.homepage = "http://jarrodpeace.com"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Horseman", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "horseman"
  s.rubygems_version = "1.8.10"
  s.summary = "Headless HTTP crawler/scraper"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.5.0"])
    else
      s.add_dependency(%q<nokogiri>, [">= 1.5.0"])
    end
  else
    s.add_dependency(%q<nokogiri>, [">= 1.5.0"])
  end
end
