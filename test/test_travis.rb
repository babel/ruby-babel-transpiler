require 'minitest/autorun'
require 'yaml'

class TestTravis < MiniTest::Test
  def test_env_source_version_matrix
    config = YAML.load(File.read(".travis.yml"))

    expected = File.read("source-versions.txt").split("\n")
      .map { |v| v.sub(/^(\d+)\.(\d+)\.(\d+)$/, '~>\1.\2.0') }
      .uniq

    actual = config["env"].map { |s| s[/^SOURCE_VERSION="(.+)"$/, 1] }

    assert_empty expected - actual
  end
end
