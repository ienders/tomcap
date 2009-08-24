require 'rubygems'
require 'hoe'
require './lib/tomcap.rb'

Hoe.new('tomcap', Tomcap::VERSION) do |p|
  p.author = 'Ian Enders'
  p.email = 'ian.enders@gmail.com'
  p.summary = 'Tomcat deployment with Capistrano'
  p.description = 'Capistrano tasks which allow you to quickly and easily deploy Java WAR files located in remote repositories (currently Artifactory repos) to a running Tomcat container.'
  p.url = 'http://github.com/ienders/tomcap/tree/master'
  p.extra_deps << ['capistrano', '>= 2.2.0']
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./lib/tomcap.rb"
end

desc "Upload site to Rubyforge"
task :site do
end

desc 'Install the package as a gem.'
task :install_gem_no_doc => [:clean, :package] do
  sh "#{'sudo ' unless Hoe::WINDOZE}gem install --local --no-rdoc --no-ri pkg/*.gem"
end
