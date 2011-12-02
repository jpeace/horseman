# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "horseman"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jarrod Peace"]
  s.date = "2011-12-01"
  s.description = "Headless http crawler/scraper for ASP.NET WebForms applications"
  s.email = "peace.jarrod@yahoo.com"
  s.extra_rdoc_files = ["README.rdoc", "lib/horseman.rb", "lib/horseman/hidden_fields.rb"]
  s.files = ["Gemfile", "Gemfile.lock", "README.rdoc", "Rakefile", "lib/horseman.rb", "lib/horseman/hidden_fields.rb", "spec/hidden_fields_spec.rb", "Manifest", "horseman.gemspec"]
  s.homepage = "http://jarrodpeace.com"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Horseman", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "horseman"
  s.rubygems_version = "1.8.10"
  s.summary = "Headless http crawler/scraper for ASP.NET WebForms applications"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
