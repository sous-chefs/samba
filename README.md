# Samba Cookbook

[![Build Status](https://travis-ci.org/sous-chefs/samba.svg?branch=master)](https://travis-ci.org/sous-chefs/samba) [![Cookbook Version](https://img.shields.io/cookbook/v/samba.svg)](https://supermarket.chef.io/cookbooks/samba)

Installs and configures Samba client or server.

## Requirements

### Platforms

- Debian / Ubuntu derivatives
- RedHat and derivatives

If you would like support for your preferred platform. Please think about creating a Vagrant Box and adding test platforms

### Chef

- Chef 12.15+

## Known Limitations

- Does not integrate with LDAP/AD.
- Uses plaintext passwords for the user resource to create the SMB users if the password backend is tdbsam or smbpasswd. See below under usage.
- Creates & manages the system user. The creation of the user is the trigger for smbpasswd.

## Recipes

### client

Installs the samba client to provide access to SMB shares.

### server

Sets up a Samba server. See below for more information on configurables.

## Resources

### User

This cookbook includes a resource/provider for managing samba users with the smbpasswd program. It will create the users home directory, and manage the user.

The creation of the user is the trigger for smbpasswd management.

The basis of this resource is the Core [user resource].

```ruby
samba_user 'jtimberman' do
  password 'plaintextpassword' # user password for samba and the system
  comment 'user_name_comment'
  home '/home/jtimberman' # Users home.
  shell '/bin/zsh' # User shell to set, e.g. /bin/sh, /sbin/nologin
  manage_home true # true/false, whether to manage the users home directory location
end
```

This resource can only create, enable or delete the user. It only supports setting the user's initial password. It assumes a password db backend that utilizes the smbpasswd program.

This will enforce the user system password set by the resource.

### Server

```ruby
samba_server 'samba server' do
  workgroup # The SMB workgroup to use, default "SAMBA".
  interfaces # Interfaces to listen on, default "lo 127.0.0.1".
  hosts_allow # Allowed hosts/networks, default "127.0.0.0/8".
  bind_interfaces_only # Limit interfaces to serve SMB, default "no"
  load_printers # Whether to load printers, default "no".
  passdb_backend # Which password backend to use, default "tdbsam".
  dns_proxy # Whether to search NetBIOS names through DNS, default "no".
  security # Samba security mode, default "user".
  map_to_guest # What Samba should do with logins that don't match Unix users, default "Bad User".
  socket_options # Socket options, default "`TCP_NODELAY`"
  config_file # Location of Samba configuration, see resource for platform default
  log_dir # Location of Samba logs, see resource for platform default
  realm # Kerberos realm to use, default: ''
  password_server # Use a specific remote server for auth, default: ''
  encrypt_passwords # Whether to negotiate encrypted passwords, default: yes
  kerberos_method # How kerberos tickets are verified, default: secrets only
  log_level # Sets the logging level from 0-10, default: 0
  winbind_separator # Define the character used when listing a username of the form of DOMAIN \user, default \
  idmap_config # Define the mapping between SIDS and Unix users and groups, default: none
  max_log_size # Maximum log file size, default: 5000, (5MB)
  options # list of additional options, e.g. 'unix charset' => 'UTF8'.
end
```

### Share

```ruby
samba_share 'Share Name' do
  comment
  guest_ok # yes, no
  printable # yes, no
  write_list # An array of Unix users
  create_mask # e.g. 0644
  directory_mask # e.g. 0700
  read_only # yes, no, default no
  create_directory # Whether to create the directory being served, default true
  valid_users # space separated users or group, default ''
  force_group # Assign Unix group as default primary, default ''
  browseable # yes, no default: yes
  options # list of additional options, e.g. 'inherit permissions' => 'yes'
  path # String for the path of directory to be served. Required.
end
```

## Usage

The `samba::default` recipe includes `samba::client`, which simply installs smbclient package.

Create a cookbook with the `server`, `user` & `share` resources as if you were using any other Chef resource.

For examples see the `test/fixtures/cookbooks/test` directory.

Unfortunately, smbpasswd does not take a hashed password as an argument - the password is echoed and piped to the smbpasswd program. This is a limitation of Samba.

## Contributors

This project exists thanks to all the people who contribute.
<img src="https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false" /></a>


### Backers

Thank you to all our backers! 🙏 [[Become a backer](https://opencollective.com/sous-chefs#backer)]
<a href="https://opencollective.com/sous-chefs#backers" target="_blank"><img src="https://opencollective.com/sous-chefs/backers.svg?width=890"></a>

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website. [[Become a sponsor](https://opencollective.com/sous-chefs#sponsor)]
<a href="https://opencollective.com/sous-chefs/sponsor/0/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/0/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/1/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/1/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/2/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/2/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/3/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/3/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/4/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/4/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/5/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/5/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/6/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/6/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/7/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/7/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/8/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/8/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/9/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/9/avatar.svg"></a>

## License

Copyright 2010-2016, Chef Software, Inc.

Copyright 2017, Webb Agile Solutions Ltd.

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

[user resource]: https://docs.chef.io/resource_user.html
