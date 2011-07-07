# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'guard/handlebars/version'

Gem::Specification.new do |s|
  s.name        = 'guard-handlebars'
  s.version     = Guard::HandlebarsVersion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Adam Williams']
  s.email       = ['adam@thewilliams.ws']
  s.homepage    = 'http://github.com/aiwilliams/guard-handlebars'
  s.summary     = 'Guard gem for Handlbars'
  s.description = 'Guard::Handlebars automatically generates client-side template JavaScripts from .handlebars files.'

  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project = 'guard-handlebars'

  s.add_dependency 'guard', '>= 0.4'

  s.add_development_dependency 'bundler',     '~> 1.0'
  s.add_development_dependency 'guard-rspec', '~> 0.4'
  s.add_development_dependency 'rspec',       '~> 2.6'

  s.files        = Dir.glob('{lib}/**/*') + %w[LICENSE README.md]
  s.require_path = 'lib'
end
