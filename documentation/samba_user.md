# `samba_user`

Manage samba users with the smbpasswd program.

The resource will create the user home directory, and manage the user.

The creation of the user is the trigger for smbpasswd management.

The basis of this resource is the Core [user resource].

This resource can only create, enable or delete the user. It only supports setting the user's initial password. It assumes a password db backend that utilizes the smbpasswd program.

This will enforce the user system password set by the resource.

## Properties

| Name        | Type                                 | Default     | Description                                         |
| ----------- | ------------------------------------ | ----------- | --------------------------------------------------- |
| password    | `String`                             |             | User password for samba and the system              |
| comment     | `String`                             |             | One (or more) comments about the user               |
| home        | `String`                             | `::File.join('/home/', name)` | Users home                        |
| shell       | `String`                             | `/bin/bash` | User shell to set                                   |
| manage_home | `true`, `false`                      | `true`      | Whether to manage the users home directory location |

## Examples

```ruby
samba_user 'jtimberman' do
  password 'plaintextpassword'
  comment 'user_name_comment'
  home '/home/jtimberman'
  shell '/bin/zsh'
  manage_home true
end
```
