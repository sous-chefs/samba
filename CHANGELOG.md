# Samba Changelog

## v1.0.4 (06-04-2017)

- Add read_only option to share. (#62 @whatcould)

## v1.0.3 (25-02-2017)

- Fixes double converges for smb.conf
- Remove 16.04 from travis test matrix whilst we investigate long term solutions to failures
- Adds Service tests
- Remove ChefSpec matchers to tidy for tidy up

## v1.0.2 (04-02-2017)

- Fix #54 Add an option to not create the directory we add to the share. Useful for including Samba variables in the share name.
- Fix #52 nmbd systemd failures in tests.

## v1.0.1 (04-02-2017)

- Fix #48 Resource underscores breaking permissions
- Fix #47 Document proper behaviour of smbpasswd. This cookbook now enforces passwords.

## v1.0.0.0 (23-01-2017)

- New custom resources `samba_server`, `samba_share`, `samba_user`
- Remove data bags!
- Removed support for Arch & SmartOS
- Add 12.1 compatibility requirement
- Move attributes out of template file and into template resource
- Use Chef built in apt-get functionality
- Remove default recipe - having a default recipe can be misleading when it doesn't do anything.
- Guard against nil options & shares
- Update README with resources and give it a general tidy.
- Remove default specs
- Use root context for template and services
- Use trusty not precise for building on travis-ci
- Remove spec directory as it duplicates inspec test & doesn't test what's now in the cookbook
- Move yum into the testing recipe to clean up dependancies.
- Ignore FC009 as it isn't being picked up correctly.

## v0.13.0 (2016-12-30)

- This cookbook is now maintained by Sous Chefs (sous-chefs.org). Expect regular updates and quicker turnaround on PRs!
- This will be the last version of this cookbook that supports Chef 11\. Pin to this version if you require Chef 11 compatibility
- Added node["samba"]["options"] for passing an array of additional options
- Added node['samba']['enable_users_search'] to enable/disable searching for samba users. Defaults to true to maintain existing behavior.
- Added SmartOS compatibility
- Added ChefSpec matchers for the LWRP
- Added `source_url` `issues_url` and `chef_version` metadata
- Removed arch and raspbian from the metadata and added oracle. We officially support systems we can test with Test Kitchen only.
- Added a Rakefile for simplified testing
- Switched integration testing to Inspec from serverspec
- Moved all testing to the 'test' cookbook and eliminated the need for the apt cookbook
- Switched to cookstyle from Rubocop and resolved all warnings
- Added testing in Travis CI
- Added a kitchen config for kitchen-dokken. Expect testing in Travis using kitchen-dokken soon
- Added a Code of Conduct doc
- Updated the Contributing docs

## v0.12.0

- Manage services at end of server recipe
- Move package and service names to attributes
- Select data bags via attributes instead of hardcoded names
- Corrected service name on Debian
- Add map to guest option in smb.conf
- Add test kitchen, chefspec, serverspec, rubocop ignore rules, and foodcritic check
- Cleanup attributes to make them easier to follow per-platform

## v0.11.4:

### Bug

- [COOK-3144]: Wrong service name in samba cookbook

## v0.11.2:

### Bug

- [COOK-2978]: samba cookbook has foodcritic errors

## v0.11.0:

- [COOK-1719] - Add Scientific / Amazon support to the Samba recipe

## v0.10.6:

- [COOK-1363] - user password assignment fails on systems using dash as default shell

## v0.10.4:

- Fixes COOK-802, typo in nmbd service name
