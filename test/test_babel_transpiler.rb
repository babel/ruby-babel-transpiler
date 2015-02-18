require 'minitest/autorun'
require 'babel/transpiler'

class TestBabelTranspiler < MiniTest::Test
  NO_RUNTIME = %w( 3.0 3.1 3.2 ).any? { |v| Babel::Transpiler.version.start_with?(v) }

  def test_source_constants
    assert Babel::Source::VERSION
    assert Babel::Source::DATE
    assert Babel::Source::PATH
  end

  def test_source_path_directory
    assert File.directory?("#{Babel::Transpiler.source_path}")
    assert File.directory?("#{Babel::Transpiler.source_path}/babel")
    assert File.file?("#{Babel::Transpiler.source_path}/babel.js")
    assert File.file?("#{Babel::Transpiler.source_path}/babel/external-helpers.js")
    assert File.file?("#{Babel::Transpiler.source_path}/babel/polyfill.js")
  end

  def test_script_path_readable
    path = Babel::Transpiler.script_path
    assert File.exist?(path)
    assert File.read(path)
  end

  def test_version
    assert Babel::Transpiler.version
    assert Babel::Transpiler.source_version
  end

  def test_transform
    code = Babel::Transpiler.transform("return [0, 2, 4].map(v => v + 1)")["code"]
    assert_equal [1, 3, 5], ExecJS.exec(code)

    code = Babel::Transpiler.transform("return (function f(x, y = 12) { return x + y; })(3)")["code"]
    assert_equal 15, ExecJS.exec(code)
  end

  def test_transform_options
    code = Babel::Transpiler.transform("ary.map(v => v + 1)", "whitelist" => ["useStrict"])["code"]
    assert_match(/strict/, code)

    code = Babel::Transpiler.transform("ary.map(v => v + 1)", "blacklist" => ["useStrict"])["code"]
    refute_match(/strict/, code)

    assert Babel::Transpiler.transform("ary.map(v => v + 1)", {}.freeze)["code"]
  end
end
