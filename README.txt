= tomcap

== DESCRIPTION:

Capistrano tasks which allow you to quickly and easily deploy Java WAR files located in remote repositories (currently Artifactory repos) to a running Tomcat container.

== REQUIREMENTS:

* capistrano (http://capify.org)
* Access to an Artifactory repository
* Some Java code you want to deploy (in WAR format) hosted in your Artifactory Maven repo.
* A running Tomcat container.  The manager port does not need to be open from your local machine. (Otherwise you could probably deploy just
 as easily without using this plugin!)

== USAGE:

= Include in capistrano

In your deploy.rb, simply include this line at the top:

require 'tomcap/recipes'

== AUTHOR:

Ian Enders
addictedtoian.com
