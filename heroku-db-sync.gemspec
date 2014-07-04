$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "heroku-db-sync/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "heroku-db-sync"
  s.version     = HerokuDbSync::VERSION
  s.authors       = ["Ole Morten Amundsen"]
  s.email         = ["ole.morten.amundsen@gmail.com"]
  s.description   = %q{adds rake task to perform backup and restore between heroku remotes}
  s.summary       = %q{rake db:sync:heroku:local}
  s.homepage      = "https://github.com/rubynor/heroku_db_sync"
  s.license       = "MIT"
  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
  #s.add_runtime_dependency "heroku"
  s.add_development_dependency "sqlite3"
end
