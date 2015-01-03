require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.warning = true
end

task :unpublished => "tmp/6to5" do
  require 'json'
  require 'open-uri'

  tags = nil
  cd "tmp/6to5" do
    sh "git fetch origin"
    tags = `git tag`.strip.split("\n").map { |t| t.sub("v", "") }
    ignore = %w(1.7 1.8 1.9 1.10 1.11 1.12)
    tags.reject! { |v| ignore.include?(v.split(".")[0, 2].join(".")) }
  end

  url = "https://rubygems.org/api/v1/versions/6to5-source.json"
  versions = JSON.parse(open(url).read).map { |v| v["number"] }
  puts tags - versions
end


task :source_gem, [:version] => "tmp/6to5" do |t, args|
  unless tag = args.version
    abort "usage: rake source_gem[1.0.0]"
  end
  tag = "v#{tag}" unless tag.start_with?("v")

  sh "git clean -fdx"

  date = nil
  cd "tmp/6to5" do
    sh "git fetch origin"
    sh "git checkout #{tag}"
    sh "npm install"
    sh "make build"
    date = `git show --format=%at | head -n1`.chomp
  end

  cp "tmp/6to5/dist/6to5.js", "lib/6to5.js"
  cp "tmp/6to5/dist/polyfill.js", "lib/6to5/polyfill.js"
  cp "tmp/6to5/dist/runtime.js", "lib/6to5/runtime.js"

  require 'erb'
  require 'json'
  erb = ERB.new(File.read("lib/6to5/source.rb.erb"))
  version = JSON.parse(File.read("tmp/6to5/package.json"))["version"]
  result = erb.result(binding)
  File.open("lib/6to5/source.rb", 'w') { |f| f.write(result) }

  sh "gem build 6to5-source.gemspec"

  sh "gem push *.gem"
  rm Dir["*.gem"]
end

directory "tmp"

file "tmp/6to5" => "tmp" do
  cd "tmp" do
    sh "git clone https://github.com/6to5/6to5"
  end
end
