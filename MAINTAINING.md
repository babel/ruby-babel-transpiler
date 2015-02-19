# Maintaining

## Releasing a new version

This project follows [semver](http://semver.org/). Any gem dependency changes
will require a new major release.

### Make a release commit

To prepare the release commit, edit the
[lib/babel/transpiler/version.rb](https://github.com/babel/ruby-babel-transpiler/blob/master/lib/babel/transpiler/version.rb)
constant. Then make a single commit with the description as
"Ruby Babel Transpiler 1.x.x". Tag the commit with `v1.x.x`. Finally, build the gem and
push it to RubyGems.

``` sh
$ git pull
$ vim lib/babel/transpiler/version.rb
$ git add lib/babel/transpiler/version.rb
$ git commit -m "Ruby Babel Transpiler 1.x.x"
$ git tag v1.x.x
$ git push
$ git push --tags
$ gem build babel-transpiler.gemspec
$ gem push babel-transpiler*.gem
```
