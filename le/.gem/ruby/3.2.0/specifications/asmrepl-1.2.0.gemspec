# -*- encoding: utf-8 -*-
# stub: asmrepl 1.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "asmrepl".freeze
  s.version = "1.2.0".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Aaron Patterson".freeze]
  s.date = "2021-12-07"
  s.description = "Tired of writing assembly and them assembling it? Now you can write assembly and evaluate it!".freeze
  s.email = "tenderlove@ruby-lang.org".freeze
  s.executables = ["asmrepl".freeze]
  s.files = ["bin/asmrepl".freeze]
  s.homepage = "https://github.com/tenderlove/asmrepl".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.rubygems_version = "3.3.0.dev".freeze
  s.summary = "Write assembly in a REPL!".freeze

  s.installed_by_version = "3.5.17".freeze if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_development_dependency(%q<minitest>.freeze, ["~> 5.14".freeze])
  s.add_development_dependency(%q<crabstone>.freeze, ["~> 4.0".freeze])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13.0".freeze])
  s.add_runtime_dependency(%q<fisk>.freeze, ["~> 2.3.1".freeze])
end
