require 'rake' 
require 'rspec/core/rake_task' 
require 'echoe'
  
Echoe.new("horseman", "0.0.1") do |p|  
  p.description     = "Headless HTTP crawler/scraper for ASP.NET WebForms applications"  
  p.url             = "http://jarrodpeace.com"  
  p.author          = "Jarrod Peace"  
  p.email           = "peace.jarrod@yahoo.com"  
  p.ignore_pattern  = FileList[".gitignore"]  
  p.development_dependencies = []  
end  
  
Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }


desc "Default task - runs specs"
task :default => :spec

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
end