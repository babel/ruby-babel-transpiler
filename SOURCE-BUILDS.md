# Babel Source Builds

The Ruby transpiler bridge is just a thin [ExecJS](https://github.com/rails/execjs) wrapper around the [Babel](https://babeljs.io) JS source. The source itself is redistributed as a  [babel-source](https://rubygems.org/gems/babel-source) RubyGem with the corresponding version. This means users can easily upgrade to the latest Babel anytime its released while maintaining Ruby API compatibility.

Babel JS releases tend be released more frequently than changes to the Ruby bridge itself. So theres some automation behind releasing the source gems.

## CI gem builds

`BUILD_SOURCE_GEM=1` is a special entry in the Travis build matrix that automatically builds and tests unpublished source gems.

A list of *local source versions* is maintained under the `source-versions/` directory. This listing is diff'd against the [published release list on rubygems.org](https://rubygems.org/gems/babel-source/versions) to get the subset of unpublished gems that should be tested.

To test a new release, `touch source-versions/1.2.3`, commit the file and push the changes.

On the Travis build matrix, see the `BUILD_SOURCE_GEM=1` job.

[![](https://cloud.githubusercontent.com/assets/137/6420712/347d80cc-be8e-11e4-9114-1bb2991c933d.png)](https://travis-ci.org/babel/ruby-babel-transpiler/builds/52399555)

This job runs the [`build-gem`](https://github.com/babel/ruby-babel-transpiler/blob/master/script/build-gem) script which fetches the [babel/babel](https://github.com/babel/babel) for the version and builds a local `.gem` file. The [`test-gem`](https://github.com/babel/ruby-babel-transpiler/blob/master/script/test-gem) then runs the test suite against the gem. This catches any changes in the babel build process or API changes that may need to be made to the Ruby bridge before releasing.

[![](https://cloud.githubusercontent.com/assets/137/6420733/626d226c-be8e-11e4-8c93-59dd17bab8a1.png)](https://travis-ci.org/babel/ruby-babel-transpiler/jobs/52399556)


### CI gem releases

While any fork can test changes against the source gem building code path, `master` has a special deployment designation.

Any unreleased source gem pushed to `master` will be automatically published to RubyGems via a Travis `after_success` [`deploy`](https://github.com/babel/ruby-babel-transpiler/blob/master/script/deploy) script. Unfortunately, none of the [official Travis deployment providers](http://docs.travis-ci.com/user/deployment/) could be used. But that may change in the future.

So core contributors may release a new source version by touching `source-versions/1.2.3` and committing to `master`. No need to worry about special RubyGem permissions.


### PR release requests

To complete the automation workflow, "release requests" are automatically published anytime a new tag is pushed to [babel/babel](https://github.com/babel/babel/releases). Contributors just should verify the build is green and should merge any new release.

[![](https://cloud.githubusercontent.com/assets/137/6420592/0827ad96-be8d-11e4-8345-de7c8bc05621.png)](https://github.com/babel/ruby-babel-transpiler/pull/111/files)

A [babel/babel](https://github.com/babel/babel/releases) Webhook is setup to POST to a Heroku instance running the [pr-release](https://github.com/babel/ruby-babel-transpiler/blob/heroku/pr-release) script. Its only responsible for opening a PR with a new `source-versions/1.x.x` file. To avoid merge conflicts, the local versions are tracked as individual files rather than a single file with a list of versions.

Should the Webhook fail or a PR need to be reopened for an older version, this can all be done manually with any GitHub user or fork. Theres nothing special about the bot account or its permissions.
