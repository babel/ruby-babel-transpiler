require File.expand_path("../lib/6to5/version.rb", __FILE__)

Gem::Specification.new do |s|
  s.name    = '6to5'
  s.version = JS6to5::VERSION

  s.homepage    = "https://github.com/6to5/ruby-6to5"
  s.summary     = "Ruby 6to5 Compiler"
  s.description = <<-EOS
    Ruby 6to5 is a bridge to the JS 6to5 compiler.
  EOS
  s.license = "MIT"

  s.files = [
    'lib/6to5.rb',
    'LICENSE'
  ]

  s.add_dependency '6to5-source'
  s.add_dependency 'execjs'
  s.add_development_dependency 'rake'

  s.authors = ['Joshua Peek']
  s.email   = 'josh@joshpeek.com'
end
