require File.expand_path("../lib/babel/transpiler/version.rb", __FILE__)

Gem::Specification.new do |s|
  s.name    = 'babel-transpiler'
  s.version = Babel::Transpiler::VERSION

  s.homepage    = "https://github.com/babel/ruby-babel-transpiler"
  s.summary     = "Ruby Babel JS Compiler"
  s.description = <<-EOS
    Ruby Babel is a bridge to the JS Babel transpiler.
  EOS
  s.license = "MIT"

  s.files = [
    'lib/babel-transpiler.rb',
    'lib/babel/transpiler.rb',
    'lib/babel/transpiler/version.rb',
    'LICENSE'
  ]

  s.add_dependency 'babel-source', '>= 4.0', '< 6'
  s.add_dependency 'execjs', '~> 2.0'
  s.add_development_dependency 'minitest', '~> 5.5'

  s.authors = ['Joshua Peek']
  s.email   = 'josh@joshpeek.com'
end
