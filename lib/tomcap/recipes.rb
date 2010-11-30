Capistrano::Configuration.instance(:must_exist).load do
  
  namespace :deploy do
    task :setup_java, :roles => :java do
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
    task :java, :roles => :java do
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

      manager_url = "#{tomcat_url}/#{fetch(:tomcat_manager_url, 'manager')}"
      context_path = "/#{mvn_war_artifact_id}-#{mvn_war_version}"

      run "curl -v -u #{tomcat_user}:#{tomcat_pass} #{manager_url}/undeploy?path=#{context_path}"
      run "curl -v -u #{tomcat_user}:#{tomcat_pass} \"#{manager_url}/deploy?path=#{context_path}&war=file:#{shared_path}/cached_java_copy/#{war_file}\""
    end
    
    namespace :tomcat  do
      desc "stop tomcat"
      task :stop, :roles => :java do
        sudo "#{tomcat_initd_script} stop ; echo '' "
      end
      desc "start tomcat"
      task :start, :roles => :java do
        sudo "#{tomcat_initd_script} start"
      end
      desc "kill tomcat processes"
      task :kill, :roles => :java do
        sudo "ps -ef | grep 'tomcat' | grep -v 'grep' | awk '{print $2}'| xargs -i kill {} ; echo ''"
      end
      desc "view running tomcat processes"
      task :processes, :roles => :java do
        puts "  ********************\n  * running tomcat processes: "
        sudo "ps -ef | grep 'tomcat'"
      end  
      desc "restart tomcat"
      task :restart, :roles => :java do
        wait_time = 60
        processes
        puts "  ********************\n  * tomcat stopping (with #{wait_time} sec wait)..."
        stop
        sleep wait_time
        processes
        puts "  ********************\n  * tomcat restarting..."
        start
        processes
      end
    end
    
  end
  
  
  before "deploy:java", "deploy:setup_java"
  
end
