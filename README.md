# Ruby Babel Transpiler

Ruby Babel is a bridge to the [JS Babel transpiler](https://babeljs.io).

``` ruby
require 'babel/transpiler'
Babel::Transpiler.transform File.read("foo.es6")
```

## Installation

``` sh
$ gem install babel-transpiler
```

## Dependencies

This library depends on the `babel-source` gem which is updated any time a new version of [Babel](https://babeljs.io) is released.

### ExecJS

The [ExecJS](https://github.com/rails/execjs) library is used to automatically choose the best JavaScript engine for your platform. Check out its [README](https://github.com/rails/execjs/blob/master/README.md) for a complete list of supported engines.
