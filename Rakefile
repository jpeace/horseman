require "rake"
require "rspec/core/rake_task"
require "echoe"
  
Echoe.new("horseman", "0.0.5") do |p|  
  p.description     = "Headless HTTP crawler/scraper"  
  p.url             = "http://jarrodpeace.com"  
  p.author          = "Jarrod Peace"  
  p.email           = "peace.jarrod@gmail.com"  
  p.ignore_pattern  = [".gitignore", "vendor/**/*", ".bundle/*"]
  p.development_dependencies = ["rake", "rspec", "echoe"]
  p.runtime_dependencies = ["nokogiri >=1.5.0", "therubyracer >=0.12.1"]
end  
  
desc "Default task - runs specs"
task :default => :spec

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = "-cfd --require spec_helper"
end
