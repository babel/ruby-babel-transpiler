require 'minitest/autorun'
require '6to5'

class Test6to5 < MiniTest::Test
  NO_RUNTIME = %w( 3.0 3.1 3.2 ).any? { |v| ES6to5.version.start_with?(v) }

  def setup
    ExecJS.runtime = ExecJS::Runtimes.autodetect
  end

  def test_source_constants
    assert ES6to5::Source::VERSION
    assert ES6to5::Source::DATE
    assert ES6to5::Source::ROOT
  end

  def test_source_path_directory
    assert File.directory?("#{ES6to5::Source.root}")
    assert File.directory?("#{ES6to5::Source.root}/6to5")
    assert File.file?("#{ES6to5::Source.root}/6to5.js")
    assert File.file?("#{ES6to5::Source.root}/6to5/polyfill.js")

    skip "no runtime.js" if NO_RUNTIME
    assert File.file?("#{ES6to5::Source.root}/6to5/runtime.js")
  end

  def test_path_readable
    path = ES6to5::Source.path
    assert File.exist?(path)
    assert File.read(path)
  end

  def test_polyfill_path_readable
    path = ES6to5::Source.polyfill_path
    assert File.exist?(path)
    assert File.read(path)
  end

  def test_runtime_path_readable
    skip "no runtime.js" if NO_RUNTIME

    path = ES6to5::Source.runtime_path
    assert File.exist?(path)
    assert File.read(path)
  end

  def test_version
    assert ES6to5.version
    assert ES6to5::Source.version
  end

  def test_transform
    code = ES6to5.transform("return [0, 2, 4].map(v => v + 1)")["code"]
    assert_equal [1, 3, 5], ExecJS.exec(code)

    code = ES6to5.transform("return (function f(x, y = 12) { return x + y; })(3)")["code"]
    assert_equal 15, ExecJS.exec(code)
  end

  def test_every_runtime
    ExecJS::Runtimes.runtimes.reject(&:deprecated?).find_all(&:available?).each do |runtime|
      ExecJS.runtime = runtime
      # just make sure it doesn't throw an error
      ES6to5.transform("return [0, 2, 4].map(v => v + 1)")["code"]
    end
  end

  def test_transform_options
    code = ES6to5.transform("ary.map(v => v + 1)", "whitelist" => ["useStrict"])["code"]
    assert_match(/strict/, code)

    code = ES6to5.transform("ary.map(v => v + 1)", "blacklist" => ["useStrict"])["code"]
    refute_match(/strict/, code)

    assert ES6to5.transform("ary.map(v => v + 1)", {}.freeze)["code"]
  end
end
