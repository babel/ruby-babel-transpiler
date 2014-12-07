require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.warning = true
end


task :source_gem, [:ref] do |t, args|
  sh "git clean -fdx"

  mkdir_p "tmp"
  unless File.exist?("tmp/6to5")
    cd "tmp" do
      sh "git clone https://github.com/6to5/6to5"
    end
  end

  date = nil
  cd "tmp/6to5" do
    sh "git checkout #{args.ref}"
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
end
