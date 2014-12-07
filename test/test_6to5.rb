require 'minitest/autorun'
require '6to5'

class Test6to5 < MiniTest::Test
  def test_source_path_directory
    assert File.directory?("#{ES6to5::Source.root}")
    assert File.directory?("#{ES6to5::Source.root}/6to5")
    assert File.file?("#{ES6to5::Source.root}/6to5.js")
    assert File.file?("#{ES6to5::Source.root}/6to5/polyfill.js")
    assert File.file?("#{ES6to5::Source.root}/6to5/runtime.js")
  end

  def test_polyfill_path_readable
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

    code = ES6to5.transform("var [a, , b] = [1,2,3]; return b")["code"]
    assert_equal 3, ExecJS.exec(code)
  end
end
