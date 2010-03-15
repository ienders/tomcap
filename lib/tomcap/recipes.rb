Capistrano::Configuration.instance(:must_exist).load do
  
  namespace :deploy do
    task :setup_java, :roles => :java, :except => { :no_release => true } do
      run "mkdir -p #{shared_path}/cached_java_copy"
    end
    
    
    desc <<-DESC
      Deploy Java WAR to a running Tomcat container.
      
      Required Arguments (examples specified):
      set :tomcat_user,         "manager"
      set :tomcat_pass,         "password"
      set :mvn_repo_user,       "artifactory"
      set :mvn_repo_pass,       "password"
      set :mvn_repository,      "libs-releases-local"
      set :mvn_war_group_id,    "com.mycompany"
      set :mvn_war_artifact_id, "my-application"
      set :mvn_war_version,     "1.0-SNAPSHOT"
      
      Optional Arguments (defaults specified):
      set :tomcat_url,          "http://localhost:8080"
      set :artifactory_url,     "http://localhost:8080/artifactory"
      set :tomcat_initd_script, "/etc/init.d/tomcat"
    DESC
    task :java, :roles => :java, :except => { :no_release => true } do
      require 'net/http'

      raise ArgumentError, "Must set tomcat_user" unless tomcat_user = fetch(:tomcat_user, nil)
      raise ArgumentError, "Must set tomcat_pass" unless tomcat_pass = fetch(:tomcat_pass, nil)
      raise ArgumentError, "Must set mvn_repo_user" unless mvn_repo_user = fetch(:mvn_repo_user, nil)
      raise ArgumentError, "Must set mvn_repo_pass" unless mvn_repo_pass = fetch(:mvn_repo_pass, nil)
      raise ArgumentError, "Must set mvn_repository" unless mvn_repository = fetch(:mvn_repository, nil)
      raise ArgumentError, "Must set mvn_war_group_id" unless mvn_war_group_id = fetch(:mvn_war_group_id, nil)
      raise ArgumentError, "Must set mvn_war_artifact_id" unless mvn_war_artifact_id = fetch(:mvn_war_artifact_id, nil)
      raise ArgumentError, "Must set mvn_war_version" unless mvn_war_version = fetch(:mvn_war_version, nil)

      war_file = "#{mvn_war_artifact_id}-#{mvn_war_version}.war"

      run "rm -rf #{shared_path}/cached_java_copy/#{war_file}"

      tomcat_url = fetch(:tomcat_url, "http://localhost:8080")
      artifactory_url = fetch(:artifactory_url, "http://localhost:8080/artifactory")

      war_path = "#{artifactory_url}/#{mvn_repository}/#{mvn_war_group_id.gsub(/\./, '/')}/#{mvn_war_artifact_id}/#{mvn_war_version}"

      run <<-CMD
        cd #{shared_path}/cached_java_copy &&
        wget #{war_path}/#{war_file} --user=#{mvn_repo_user} --password=#{mvn_repo_pass}
      CMD

      manager_url = "#{tomcat_url}/manager"
      context_path = "/#{mvn_war_artifact_id}-#{mvn_war_version}"

      run "curl -v -u #{tomcat_user}:#{tomcat_pass} #{manager_url}/undeploy?path=#{context_path}"
      run "curl -v -u #{tomcat_user}:#{tomcat_pass} \"#{manager_url}/deploy?path=#{context_path}&war=file:#{shared_path}/cached_java_copy/#{war_file}\""
    end
  end
  
  namespace :tomcat  do
    task :stop do
      sudo "#{tomcat_initd_script} stop"
    end

    task :start do
      sudo "#{tomcat_initd_script} start"
    end

    task :restart do
      stop_tomcat
      puts "tomcat stopping..."
      sleep 30
      puts "tomcat restarting..."
      start_tomcat
    end
  end
  
  before "deploy:java", "deploy:setup_java"
  
end