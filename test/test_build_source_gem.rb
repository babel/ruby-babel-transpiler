require 'minitest/autorun'

class TestBuildSourceGem < MiniTest::Test
  def test_build_latest_source_gem
    version = File.read("source-versions.txt").split("\n").last
    output = `rake vendor/cache/6to5-source-#{version}.gem 2>&1`
    assert $?.success?, output
  end
end
