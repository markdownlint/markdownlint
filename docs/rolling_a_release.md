# Rolling a new release

Bump the version. Markdownlint uses semantic versioning. From
<http://semver.org/>:

* Major version for backwards-incompatible changes
* Minor version functionality added in a backwards-compatible manner
* Patch version for backwards-compatible bug fixes
* Exception: Versions < 1.0 may introduce backwards-incompatible changes in a
  minor version.

To bump the version, edit `lib/mdl/version.rb` and commit to the master
branch.

Next, run `rake release`. This will:

* Tag vX.Y.Z in git and push it.
* Upload the new gem to rubygems.org
