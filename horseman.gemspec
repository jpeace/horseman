# -*- encoding: utf-8 -*-
# stub: horseman 0.0.5 ruby lib

Gem::Specification.new do |s|
  s.name = "horseman"
  s.version = "0.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jarrod Peace"]
  s.date = "2015-04-04"
  s.description = "Headless HTTP crawler/scraper"
  s.email = "peace.jarrod@gmail.com"
  s.extra_rdoc_files = ["README.md", "lib/horseman.rb", "lib/horseman/action.rb", "lib/horseman/browser.rb", "lib/horseman/browser/location.rb", "lib/horseman/browser/output.rb", "lib/horseman/browser/whiny_v8.rb", "lib/horseman/browser/window.rb", "lib/horseman/connection.rb", "lib/horseman/cookies.rb", "lib/horseman/dom/document.rb", "lib/horseman/dom/element.rb", "lib/horseman/dom/form.rb", "lib/horseman/dom/script.rb", "lib/horseman/javascript_engine.rb", "lib/horseman/response.rb", "lib/horseman/version.rb"]
  s.files = ["Gemfile", "Gemfile.lock", "Manifest", "README.md", "Rakefile", "horseman.gemspec", "lib/horseman.rb", "lib/horseman/action.rb", "lib/horseman/browser.rb", "lib/horseman/browser/location.rb", "lib/horseman/browser/output.rb", "lib/horseman/browser/whiny_v8.rb", "lib/horseman/browser/window.rb", "lib/horseman/connection.rb", "lib/horseman/cookies.rb", "lib/horseman/dom/document.rb", "lib/horseman/dom/element.rb", "lib/horseman/dom/form.rb", "lib/horseman/dom/script.rb", "lib/horseman/javascript_engine.rb", "lib/horseman/response.rb", "lib/horseman/version.rb", "spec/horseman/action_spec.rb", "spec/horseman/browser_spec.rb", "spec/horseman/connection_spec.rb", "spec/horseman/cookies_spec.rb", "spec/horseman/dom/document_spec.rb", "spec/spec_helper.rb", "spec/support/doubles.rb", "spec/support/patches.rb", "spec/support/patches/io.rb", "spec/support/patches/open_uri.rb"]
  s.homepage = "http://jarrodpeace.com"
  s.rdoc_options = ["--line-numbers", "--title", "Horseman", "--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "horseman"
  s.rubygems_version = "2.1.5"
  s.summary = "Headless HTTP crawler/scraper"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.5.0"])
      s.add_runtime_dependency(%q<therubyracer>, [">= 0.10.1"])
    else
      s.add_dependency(%q<nokogiri>, [">= 1.5.0"])
      s.add_dependency(%q<therubyracer>, [">= 0.10.1"])
    end
  else
    s.add_dependency(%q<nokogiri>, [">= 1.5.0"])
    s.add_dependency(%q<therubyracer>, [">= 0.10.1"])
  end
end
