# Samba Changelog

## v0.13.0 (2016-12-30)

- This cookbook is now maintained by Sous Chefs (sous-chefs.org). Expect regular updates and quicker turnaround on PRs!
- This will be the last version of this cookbook that supports Chef 11\. Pin to this version if you require Chef 11 compatibility
- Added node["samba"]["options"] for passing an array of additional options
- Added node['samba']['enable_users_search'] to enable/disable searching for samba users. Defaults to true to maintain existing behavior.
- Added SmartOS compatibility
- Added ChefSpec matchers for the LWRP
- Added source_url issues_url and chef_version metadata
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
