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

Update the changelog:

* Add a new header and 'full changelog' link for the new release:

        ## [v0.2.0](https://github.com/mivok/markdownlint/tree/v0.2.0) (2015-04-13)

        [Full Changelog](https://github.com/mivok/markdownlint/compare/v0.1.0...v0.2.0)

* Add an 'Rules added' section, listing every new rule added for this version.
  * Use `git diff v0.1.0..v0.2.0 docs/RULES.md | grep '## MD'` to discover
    what these are.
* Search for closed issues:
  * Go to <https://github.com/mivok/markdownlint/issues>
  * Search for `is:closed closed:>1900-01-01`, changing the date to the date
    of the last release.
  * From this list of issues, make sections for:
    * Enhancements implemented
    * Bugs fixed
* Search for merged pull requests:
  * Search for `is:pull-request  merged:>1900-01-01`
  * Add an entry for each merged pull request:
    * `[Title - author](https://github.com/mivok/markdownlint/pull/NN)`

Next, run `rake release`. This will:

* Tag vX.Y.Z in git and push it.
* Upload the new gem to rubygems.org
