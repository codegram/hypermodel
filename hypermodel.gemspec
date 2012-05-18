$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "hypermodel/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "hypermodel"
  s.version     = Hypermodel::VERSION
  s.authors     = ["Josep M. Bach"]
  s.email       = ["josep.m.bach@gmail.com"]
  s.homepage    = "https://github.com/codegram/hypermodel"
  s.summary     = "Rails Responder to generate an automagic JSON HAL representation for your Mongoid models"
  s.description = "Rails Responder to generate an automagic JSON HAL representation for your Mongoid models"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.3"
  s.add_dependency "mongoid"

  s.add_development_dependency "sqlite3"
end
