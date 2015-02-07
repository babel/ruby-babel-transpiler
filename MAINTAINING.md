# Maintaining

## Releasing a new version

This project follows [semver](http://semver.org/). Any gem dependency changes
will require a new major release.

### Make a release commit

To prepare the release commit, edit the
[lib/6to5/version.rb](https://github.com/6to5/ruby-6to5/blob/master/lib/6to5/version.rb)
constant. Then make a single commit with the description as
"Ruby 6to5 1.x.x". Tag the commit with `v1.x.x`. Finally, build the gem and
push it to RubyGems.

``` sh
$ git pull
$ vim lib/6to5/version.rb
$ git add lib/6to5/version.rb
$ git commit -m "Ruby 6to5 1.x.x"
$ git tag v1.x.x
$ git push
$ git push --tags
$ gem build 6to5.gemspec
$ gem push 6to5*.gem
```

## Releasing a new source version

`6to5-source` gems are build separately and are not checked into git.

``` sh
$ ./script/publish-gem 1.0.0
```
