# `samba_share`

Creates shares for use with Samba

## Properties

| Name             | Type            | Default                                                       | Allowed Values | Description                                                                                                      |
| ---------------- | --------------- | ------------------------------------------------------------- | -------------- | ---------------------------------------------------------------------------------------------------------------- |
| share_name       | String          |                                                               |                | The name of the share                                                                                            |
| comment          | String          |                                                               |                | Comment string to associate with the new share                                                                   |
| path             | String          |                                                               |                | Path to directory to share                                                                                       |
| valid_users      | String          |                                                               |                | A string of allowed users                                                                                        |
| force_group      | String          |                                                               |                | Force ownership of files on the share to specified group                                                         |
| force_user       | String          |                                                               |                | Force ownership of files on the share to specified user                                                          |
| browseable       | String          | `'yes'`                                                       | `'yes'` `'no'` | Controls whether this share is seen in the list of available shares in a net view and in the browse list         |
| guest_ok         | String          | `'no'`                                                        | `'yes'` `'no'` | Allow anoymous access to the share                                                                               |
| printable        | String          | `'no'`                                                        | `'yes'` `'no'` | If set to yes, then clients may open, write to and submit spool files on the directory specified for the service |
| write_list,      | Array           |                                                               |                | An array of Unix users allowed to write to the share                                                             |
| create_mask      | String          | `'0744'`                                                      |                | Create mask for directory                                                                                        |
| directory_mask,  | String          | `'0755'`                                                      |                | Mask for directory                                                                                               |
| read_only        | String          | `'no'`                                                        | `'yes'` `'no'` | Whether files on the share are writeable                                                                         |
| create_directory | `[true, false]` | `true`                                                        |                | Whether to create the new share directory on disk                                                                |
| options          | Hash            | `{}`                                                          |                | A hash of extra options to pass to the configuration file                                                        |
| config_file      | String          | `'/opt/local/etc/samba/smb.conf'` or  `'/etc/samba/smb.conf'` |                | Path to the samba configuration file                                                                             |

## Examples

```ruby
samba_share 'company-x' do
  comment 'Shared fiels for company X'
  guest_ok 'no'
  write_list %w(dave bob)
  read_only 'no'
  valid_users 'dave bob'
  options  {
    'inherit permissions' => 'yes'
  }
  path '/srv/company_x'
end
