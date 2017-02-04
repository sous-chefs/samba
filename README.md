# Samba Cookbook

[![Build Status](https://travis-ci.org/sous-chefs/samba.svg?branch=master)](https://travis-ci.org/sous-chefs/samba) [![Cookbook Version](https://img.shields.io/cookbook/v/samba.svg)](https://supermarket.chef.io/cookbooks/samba)

Installs and configures Samba client or server.

## Requirements

### Platforms

- Debian / Ubuntu derivatives
- RedHat and derivatives

If you would like support for your preferred platform. Please think about creating a Vagrant Box and adding test platforms

### Chef

- Chef 12.1+

### Cookbooks

- none

## Known Limitations

- Does not (yet) integrate with LDAP/AD.
- Uses plaintext passwords for the user resource to create the SMB users if the password backend is tdbsam or smbpasswd. See below under usage.

## Recipes

### client

Installs smbclient to provide access to SMB shares.

### server

Sets up a Samba server. See below for more information on defaults.

## Resources

### User

This cookbook includes a resource/provider for managing samba users with the smbpasswd program.

```ruby
samba_user 'jtimberman' do
  password 'plaintextpassword'
  comment 'user_name_comment'
  home '/home/jtimberman'
  shell '/bin/zsh'
end
```

This resource can only create, enable or delete the user. It only supports setting the user's initial password. It assumes a password db backend that utilizes the smbpasswd program.

This will enforce the password set by the resource. Meaning, if the local user changes their password with `smbpasswd`, the recipe will reset it.

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
end
```

## Usage

The `samba::default` recipe includes `samba::client`, which simply installs smbclient package.

Create a cookbook with the `server`, `user` & `share` resources as if you were using any other Chef resource.

For examples see the `test/fixtures/cookbooks/test` directory.

Unfortunately, smbpasswd does not take a hashed password as an argument - the password is echoed and piped to the smbpasswd program. This is a limitation of Samba.

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
