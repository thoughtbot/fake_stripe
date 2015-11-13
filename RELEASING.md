# Releasing

1. Ask to be added as an owner for this gem on RubyGems.org.
1. Update the `VERSION` constant.
1. Run `bundle update` to update `Gemfile.lock`.
1. Run the test suite.
1. Edit `NEWS`, `Changelog`, or `README` files if relevant.
1. Commit changes. Use the convention "v2.1.0" in your commit message.
1. Run `rake release`, which tags the release, pushes the tag to GitHub, and
   pushes the gem to RubyGems.org.
