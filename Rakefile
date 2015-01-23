require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.warning = true
end

rule /tmp\/6to5-source-/ do |task|
  mkdir_p dir = task.name

  require 'json'

  version = date = nil
  cd "tmp/6to5" do
    sh "git fetch origin"
    sh "git checkout v#{dir.sub("tmp/6to5-source-", "")}"
    sh "npm install"
    sh "make build"
    date = `git show --format=%at | head -n1`.chomp
    version = JSON.parse(File.read("package.json"))["version"]
  end

  mkdir_p dir
  cp "6to5-source.gemspec", "#{dir}/6to5-source.gemspec"

  mkdir_p "#{dir}/lib/6to5"
  cp "tmp/6to5/dist/6to5.js", "#{dir}/lib/6to5.js"
  cp "tmp/6to5/dist/polyfill.js", "#{dir}/lib/6to5/polyfill.js"
  cp "tmp/6to5/dist/runtime.js", "#{dir}/lib/6to5/runtime.js"

  require 'erb'
  erb = ERB.new(File.read("lib/6to5/source.rb.erb"))
  result = erb.result(binding)
  File.open("#{dir}/lib/6to5/source.rb", 'w') { |f| f.write(result) }
end

task :source_gem, [:version] => "tmp/6to5" do |t, args|
  unless version = args.version
    abort "usage: rake source_gem[1.0.0]"
  end
  version.gsub!("v", "")

  Rake::Task["tmp/6to5-source-#{version}"].invoke

  cd "tmp/6to5-source-#{version}" do
    sh "gem build 6to5-source.gemspec"
    sh "gem install 6to5-source-#{version}.gem"
  end

  ENV["SOURCE_VERSION"] = version
  sh "bundle install"
  sh "bundle exec rake test"

  sh "gem push tmp/6to5-source-#{version}/6to5-source-#{version}.gem"
end

directory "tmp"

file "tmp/6to5" => "tmp" do
  cd "tmp" do
    sh "git clone https://github.com/6to5/6to5"
  end
end
