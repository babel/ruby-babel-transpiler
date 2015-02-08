require 'minitest/autorun'

if ENV['VALIDATE_TRAVIS']
  require 'json'
  require 'open-uri'
  require 'set'
  require 'yaml'

  class TestTravis < MiniTest::Test
    def test_env_source_version_matrix
      url = "https://rubygems.org/api/v1/versions/6to5-source.json"
      published = version_constraints(JSON.parse(open(url).read).map { |v| v["number"] })

      local = version_constraints(File.read("source-versions.txt").split("\n"))

      config = YAML.load(File.read(".travis.yml"))
      travis = Set.new(config["env"].map { |s| s[/^SOURCE_VERSION="(.+)"$/, 1] }.compact)

      missing = (published & local) - travis
      assert_empty missing, "Add the following envs to .travis.yml: \n" +
        missing.map { |v| "- SOURCE_VERSION=\"#{v}\"" }.join("\n")
    end

    def version_constraints(versions)
      Set.new(versions.compact.map { |v| v.sub(/^(\d+)\.(\d+)\.(\d+)$/, '~>\1.\2.0') })
    end
  end
end
