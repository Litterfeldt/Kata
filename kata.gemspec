# encoding: utf-8

$:.push File.expand_path("../app", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'Kata'
  s.version     = '0.1'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Karl Litterfeldt"]

  s.homepage    = ""
  s.summary     = %q{}
  s.description = %q{}

  s.files       = Dir.glob("app/**/*") + %w(Gemfile kata.gemspec)
  s.test_files  = Dir.glob('spec/**/*')

  s.add_dependency 'sinatra'
  s.add_dependency 'sinatra-contrib'
  s.add_dependency 'redis'
  s.add_dependency 'redis-namespace'
  s.add_dependency 'thin'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'fakeredis'
  s.add_development_dependency 'cane'
  s.add_development_dependency 'capybara-angular'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'capybara-webkit'
end
