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
      set :tomcat_url,      "http://localhost:8080"
      set :artifactory_url, "http://localhost:8080/artifactory"
    DESC
    task :java, :roles => :java, :except => { :no_release => true } do
      raise ArgumentError, "Must set tomcat_user" unless tomcat_user
      raise ArgumentError, "Must set tomcat_pass" unless tomcat_pass
      raise ArgumentError, "Must set mvn_repo_user" unless mvn_repo_user
      raise ArgumentError, "Must set mvn_repo_pass" unless mvn_repo_pass
      raise ArgumentError, "Must set mvn_repository" unless mvn_repository
      raise ArgumentError, "Must set mvn_war_group_id" unless mvn_war_group_id
      raise ArgumentError, "Must set mvn_war_artifact_id" unless mvn_war_artifact_id
      raise ArgumentError, "Must set mvn_war_version" unless mvn_war_version
      
      tomcat_url = fetch(:tomcat_url, "http://localhost:8080")
      artifactory_url = fetch(:artifactory_url, "http://localhost:8080/artifactory")
      
      war_path = "#{artifactory_url}/#{mvn_repository}/#{mvn_war_group_id.gsub(/\./, '/')}/#{mvn_war_artifact_id}/#{mvn_war_version}"
      war_file = "#{mvn_war_artifact_id}-#{mvn_war_version}.war"
      
      run <<-CMD
        cd #{shared_path}/cached_java_copy &&
        wget #{war_path}/#{war_file}" &&
        curl -F "@#{war_file}" #{tomcat_url}/manager/deploy?path=#{mvn_war_artifact_id}-#{mvn_war_version}&update=true
      CMD
    end    
  end
  
  before "deploy:java", "deploy:setup_java"
  
end