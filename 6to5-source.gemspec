require File.expand_path("../lib/6to5/source.rb", __FILE__)

Gem::Specification.new do |s|
  s.name = '6to5-source'
  s.version = ES6to5::Source::VERSION
  s.date = ES6to5::Source::DATE

  s.summary = "6to5 source"
  s.homepage = "https://github.com/6to5/ruby-6to5"
  s.license = "MIT"

  s.files = [
    'lib/6to5.js',
    'lib/6to5/polyfill.js',
    'lib/6to5/runtime.js',
    'lib/6to5/source.rb'
  ]

  s.authors = ['Sebastian McKenzie']
  s.email   = 'sebmck@gmail.com'
end
