Gem::Specification.new do |s|
  s.name = %q{tomcap}
  s.version = "0.1"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ian Enders"]
  s.date = %q{2009-08-24}
  s.description = %q{Capistrano tasks which allow you to quickly and easily deploy Java WAR files located in remote repositories (currently Artifactory repos) to a running Tomcat container.}
  s.email = %q{ian.enders@gmail.com}
  s.files = ["History.txt", "Manifest.txt", "README.txt", "lib/tomcap.rb", "lib/tomcap/recipes.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/ienders/tomcap/tree/master}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.0.1}
  s.summary = %q{Tomcat deployments with Capistrano}

  s.add_dependency(%q<capistrano>, [">= 2.2.0"])
  s.add_dependency(%q<hoe>, [">= 1.5.1"])
end
