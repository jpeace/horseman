# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "horseman"
  s.version = "0.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jarrod Peace"]
  s.date = "2012-03-29"
  s.description = "Headless HTTP crawler/scraper"
  s.email = "peace.jarrod@gmail.com"
  s.extra_rdoc_files = ["README.rdoc", "lib/horseman.rb", "lib/horseman/action.rb", "lib/horseman/browser.rb", "lib/horseman/browser/location.rb", "lib/horseman/browser/output.rb", "lib/horseman/browser/whiny_v8.rb", "lib/horseman/browser/window.rb", "lib/horseman/connection.rb", "lib/horseman/cookies.rb", "lib/horseman/dom/document.rb", "lib/horseman/dom/element.rb", "lib/horseman/dom/form.rb", "lib/horseman/dom/script.rb", "lib/horseman/javascript_engine.rb", "lib/horseman/response.rb", "lib/horseman/version.rb"]
  s.files = Dir.glob("{lib}/**/*") + %w(README.rdoc)
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
      s.add_runtime_dependency(%q<therubyracer>, [">= 0"])
    else
      s.add_dependency(%q<nokogiri>, [">= 1.5.0"])
      s.add_dependency(%q<therubyracer>, [">= 0"])
    end
  else
    s.add_dependency(%q<nokogiri>, [">= 1.5.0"])
    s.add_dependency(%q<therubyracer>, [">= 0"])
  end
end
