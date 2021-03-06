= tomcap

== DESCRIPTION:

Capistrano tasks which allow you to quickly and easily deploy Java WAR files located in remote repositories (currently Artifactory repos) to a running Tomcat container.

== REQUIREMENTS:

* capistrano (http://capify.org)
* Access to an Artifactory repository
* Some Java code you want to deploy (in WAR format) hosted in your Artifactory Maven repo.
* A running Tomcat container.  The manager port does not need to be open from your local machine. (Otherwise you could probably deploy just
 as easily without using this plugin!)

== INSTALLATION:

No longer hosted in git gems.  From 1.0.3+ can be found in RubyGems.

 $ gem install tomcap

== USAGE:

= Include in capistrano

In your deploy.rb, simply include this line at the top:

  require 'tomcap/recipes'

NEW: If you're using Tomcat 7, instead, require recipes7 (everything else is the same aside from standard Tomcat permission changes).

  require 'tomcap/recipes7'

= Set your configuration parameters

  set :tomcat_user,         "..."
  set :tomcat_pass,         "..."

  set :mvn_repo_user,       "..."
  set :mvn_repo_pass,       "..."

  set :mvn_repository,      "libs-snapshots-local"
  set :mvn_war_group_id,    "com.mycompany"
  set :mvn_war_artifact_id, "my-application"
  set :mvn_war_version,     "1.0-SNAPSHOT"

= Assign a java role to all servers hosting your app

  role :java, 'myhost.com'

= Deploy

  $ cap <environment> deploy:java

== AUTHOR:

Ian Enders
addictedtoian.com
