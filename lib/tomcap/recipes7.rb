require 'tomcap/recipes'

Capistrano::Configuration.instance(:must_exist).load do
  
  namespace :deploy do
    task :set_tomcat7_manager_url, :roles => :java do
      set :tomcat_manager_url, 'manager/text'
    end
  end
  
  before "deploy:setup_java", "deploy:set_tomcat7_manager_url"
  
end
