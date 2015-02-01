require 'erb'
require 'json'
require 'open-uri'
require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.warning = true
end


def published_source_versions
  url = "https://rubygems.org/api/v1/versions/6to5-source.json"
  versions = JSON.parse(open(url).read).map { |v| v["number"] }
  versions.reverse
end

def unpublished_source_versions
  versions = File.read("source-versions.txt").split("\n")
  published_source_versions - versions
end

task "source-versions.txt" do |task|
  File.open(task.name, 'w') do |f|
    published_source_versions.each { |v| f.puts v }
  end
end

directory "tmp"

file "tmp/6to5" => "tmp" do
  cd "tmp" do
    sh "git clone https://github.com/6to5/6to5"
  end
end

rule /^tmp\/6to5-source-(\d+)\.(\d+)\.(\d+)$/ do |task|
  mkdir_p dir = task.name

  version = date = nil
  cd "tmp/6to5" do
    sh "git fetch origin"
    sh "git checkout v#{dir.sub("tmp/6to5-source-", "")}"
    sh "npm install"
    sh "make build"
    date = `git show --format=%at | head -n1`.chomp
    version = JSON.parse(File.read("package.json"))["version"]
  end

  mkdir_p "#{dir}/lib/6to5"
  cp "tmp/6to5/dist/6to5.js", "#{dir}/lib/6to5.js"
  cp "tmp/6to5/dist/polyfill.js", "#{dir}/lib/6to5/polyfill.js"
  cp "tmp/6to5/dist/runtime.js", "#{dir}/lib/6to5/runtime.js"

  mkdir_p dir
  erb = ERB.new(File.read("6to5-source.gemspec.erb"))
  result = erb.result(binding)
  File.open("#{dir}/6to5-source.gemspec", 'w') { |f| f.write(result) }

  erb = ERB.new(File.read("lib/6to5/source.rb.erb"))
  result = erb.result(binding)
  File.open("#{dir}/lib/6to5/source.rb", 'w') { |f| f.write(result) }
end

directory "vendor/cache"

rule /^vendor\/cache\/6to5-source-(\d+)\.(\d+)\.(\d+)\.gem$/ => "vendor/cache" do |task|
  version = task.name[/(\d+)\.(\d+)\.(\d+)/, 0]
  Rake::Task["tmp/6to5-source-#{version}"].invoke

  cd "tmp/6to5-source-#{version}" do
    sh "gem build 6to5-source.gemspec"
  end

  mv "tmp/6to5-source-#{version}/6to5-source-#{version}.gem", "vendor/cache"
end

task :publish => "tmp/6to5" do
  unpublished_source_versions.each do |version|
    puts "=" * 80
    puts "Releasing 6to5-source #{version}"
    puts "=" * 80

    Rake::Task["vendor/cache/6to5-source-#{version}.gem"].invoke

    ENV["SOURCE_VERSION"] = version
    rm_f "Gemfile.lock"
    sh "bundle install --no-prune"
    sh "bundle exec rake test"

    sh "gem push tmp/6to5-source-#{version}/6to5-source-#{version}.gem"
  end
end
