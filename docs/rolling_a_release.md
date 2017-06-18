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

* Add a new header and link for the new release, replacing any 'Unreleased'
  header.

        ## [v0.2.0] (2015-04-13)

        This goes at the bottom:

        [v0.2.0]: https://github.com/markdownlint/markdownlint/tree/v0.2.0

* Changelog entries can and should be added in an 'Unreleased' section as
  commits are made. However, the following steps can be performed before each
  release to catch anything that was missed.
* Add a 'Rules added' section, listing every new rule added for this version.
  * Use `git diff v0.1.0..v0.2.0 docs/RULES.md | grep '## MD'` to discover
    what these are.
* Search for closed issues:
  * Go to <https://github.com/markdownlint/markdownlint/issues>
  * Search for `closed:>1900-01-01`, changing the date to the date
    of the last release.
  * From this list of issues, make sections for:
    * Added - for new features
    * Changed - for changes in existing functionality
    * Deprecated - for once-stable features removed in upcoming releases
    * Removed - for deprecated features removed in this release
    * Fixed - for any bug fixes
    * Security - for any security issues

Next, run `rake release`. This will:

* Tag vX.Y.Z in git and push it.
* Upload the new gem to rubygems.org

Finally, add a new 'Unreleased' section to the changelog for the next release.
