# Ruby 6to5 Compiler

Ruby 6to5 is a bridge to the JS 6to5 compiler.

``` ruby
require '6to5'
6to5.transform File.read("foo.es6")
```

## Installation

``` sh
$ gem install 6to5
```

## Dependencies

This library depends on the `6to5-source` gem which is updated any time a new version of 6to5 is released.

### ExecJS

The [ExecJS](https://github.com/sstephenson/execjs) library is used to automatically choose the best JavaScript engine for your platform. Check out its [README](https://github.com/sstephenson/execjs/blob/master/README.md) for a complete list of supported engines.
