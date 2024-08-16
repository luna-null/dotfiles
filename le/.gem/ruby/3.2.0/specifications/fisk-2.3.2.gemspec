# -*- encoding: utf-8 -*-
# stub: fisk 2.3.2 ruby lib

Gem::Specification.new do |s|
  s.name = "fisk".freeze
  s.version = "2.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Aaron Patterson".freeze]
  s.date = "2023-04-07"
  s.description = "Tired of writing Ruby in Ruby? Now you can write assembly in Ruby!".freeze
  s.email = "tenderlove@ruby-lang.org".freeze
  s.homepage = "https://github.com/tenderlove/fisk".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.rubygems_version = "3.4.19".freeze
  s.summary = "Write assembly in Ruby!".freeze

  s.installed_by_version = "3.4.19" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_development_dependency(%q<minitest>.freeze, ["~> 5.14"])
  s.add_development_dependency(%q<crabstone>.freeze, ["~> 4.0"])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
  s.add_development_dependency(%q<nokogiri>.freeze, ["~> 1.11"])
end
