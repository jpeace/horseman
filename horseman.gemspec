# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "horseman"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jarrod Peace"]
  s.date = "2011-12-13"
  s.description = "Headless HTTP crawler/scraper for ASP.NET WebForms applications"
  s.email = "peace.jarrod@gmail.com"
  s.extra_rdoc_files = ["README.rdoc", "lib/horseman.rb", "lib/horseman/cookie.rb", "lib/horseman/hidden_fields.rb", "lib/horseman/version.rb"]
  s.files = ["Gemfile", "Gemfile.lock", "Manifest", "README.rdoc", "Rakefile", "horseman.gemspec", "lib/horseman.rb", "lib/horseman/cookie.rb", "lib/horseman/hidden_fields.rb", "lib/horseman/version.rb", "spec/cookie_spec.rb", "spec/hidden_fields_spec.rb"]
  s.homepage = "http://jarrodpeace.com"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Horseman", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "horseman"
  s.rubygems_version = "1.8.10"
  s.summary = "Headless HTTP crawler/scraper for ASP.NET WebForms applications"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
