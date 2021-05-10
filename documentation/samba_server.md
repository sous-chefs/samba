# `samba_server`

Installs and configures Samba server

| Name                 | Type                   | Default                 | Allowed Values                           | Description                                                            |
| -------------------- | ---------------------- | ----------------------- | ---------------------------------------- | ---------------------------------------------------------------------- |
| server_string        | String                 |                         | Name of the server                       |                                                                        |
| workgroup            | String                 | `'SAMBA'`'              |                                          | The SMB workgroup to use                                               |
| interfaces           | String                 | `'lo 127.0.0.1'`        |                                          | Interfaces to listen on                                                |
| hosts_allow          | String `'127.0.0.0/8'` |                         |                                          | Allowed hosts/networks                                                 |
| bind_interfaces_only | String                 | `'no'`                  | `'yes' 'no'`                             | Limit interfaces to serve SMB                                          |
| load_printers        | String                 | `'no'`                  | `'yes' 'no'`                             | Whether to load printers                                               |
| passdb_backend       | String                 | `'tdbsam'`              | 'ldapsam' 'tdbsam' 'smbpasswd'           | Which password backend to use                                          |
| dns_proxy            | String                 | `'no'`                  | `'yes'` `'no'`                           | Whether to search NetBIOS names through DNS                            |
| security             | String                 | `'user'`                | `'user' 'domain' 'ADS' 'share' 'server'` | Samba security mode                                                    |
| map_to_guest         | String                 | `'Bad User'`            |                                          | What Samba should do with logins that do not match Unix users          |
| realm                | String                 |                         |                                          | Kerberos realm to use                                                  |
| kerberos_method      | String                 | `'secrets only'`        | See resource for full list               | How kerberos tickets are verified                                      |
| password_server      | String                 | `'*'`                   |                                          | Use a specific remote server for auth                                  |
| encrypt_passwords    | String                 | `'yes'`                 | `'yes' 'no'`                             | Whether to negotiate encrypted passwords                               |
| log_level            | String, Integer        | `'0'`                   |                                          | Sets the logging level from 0-10'                                      |
| winbind_separator    | String                 | `\`                     |                                          | The character used when listing a username of the form of DOMAIN \user |
| idmap_config         | String                 |                         |                                          | Define the mapping between SIDS and Unix users and groups              |
| socket_options       | String, Integer        | '`TCP_NODELAY`'         | See resource for full list               | Options for connection tuning                                          |
| log_dir              | String,                | Platform specific value |                                          | Location of Samba logs                                                 |
| max_log_size         | String, Integer        | 5000                    |                                          | Maximum log file size                                                  |
| options              | Hash                   |                         |                                          | Hash of additional options                                             |
| config_file          | String                 | `'/etc/samba/smb.conf'` |                                          | Location of Samba configuration'                                       |
| samba_services       | Array                  | Platform specific value |                                          | An array of services to start                                          |

## Examples

```ruby
samba_server 'samba server' do
  workgroup 'FOXTROT'
  interfaces 'lo 192.168.0.1'
  hosts_allow '192.168.0.0/8'
  passdb_backend 'smbpasswd'
  security 'domain'
  options { 'unix charset' => 'UTF8' }
end
```
