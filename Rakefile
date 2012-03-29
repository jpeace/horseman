require 'rake' 
require 'rspec/core/rake_task' 
require 'echoe'
  
Echoe.new("horseman", "0.0.5") do |p|  
  p.description     = "Headless HTTP crawler/scraper"  
  p.url             = "http://jarrodpeace.com"  
  p.author          = "Jarrod Peace"  
  p.email           = "peace.jarrod@gmail.com"  
  p.ignore_pattern  = FileList[".gitignore"]  
  p.development_dependencies = []  
  p.runtime_dependencies = ["nokogiri >=1.5.0", "therubyracer"]
end  
  
Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }


desc "Default task - runs specs"
task :default => :spec

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = '-cfd --require spec_helper'
end