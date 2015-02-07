require 'minitest/autorun'

if ENV['BUILD_SOURCE_GEM']
  class TestBuildSourceGem < MiniTest::Test
    `./script/unpublished-source-versions`.split("\n").each do |version|
      define_method "test_build_source_gem #{version}" do
        command = "./script/test-gem #{version}"
        output = `#{command} 2>&1`
        assert $?.success?, "$ #{command}\n#{output}"
      end
    end
  end
end
