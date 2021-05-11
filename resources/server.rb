#
# Cookbook:: samba
# Resource:: server
#
# Copyright:: 2010-2016, Chef Software, Inc <legal@opscode.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

unified_mode true

property :server_string,
        String,
        name_property: true,
        description: 'Name of the server'

property :workgroup,
        String,
        default: 'SAMBA',
        description: 'The SMB workgroup to use'

property :interfaces,
        String,
        default: 'lo 127.0.0.1',
        description: 'Interfaces to listen on'

property :hosts_allow,
        String,
        default: '127.0.0.0/8',
        description: 'Allowed hosts/networks'

property :bind_interfaces_only,
        [true, false],
        default: false,
        coerce: proc { |p| p ? 'yes' : 'no' },
        description: 'Limit interfaces to serve SMB'

property :load_printers,
        [true, false],
        default: false,
        coerce: proc { |p| p ? 'yes' : 'no' },
        description: 'Whether to load printers'

property :passdb_backend,
        String,
        default: 'tdbsam',
        equal_to: %w(ldapsam tdbsam smbpasswd),
        description: 'Which password backend to use'

property :dns_proxy,
        [true, false],
        default: false,
        coerce: proc { |p| p ? 'yes' : 'no' },
        description: 'Whether to search NetBIOS names through DNS'

property :security,
        String,
        default: 'user',
        equal_to: %w(user domain ADS share server),
        description: 'Samba security mode'

property :map_to_guest,
        String,
        default: 'Bad User',
        description: 'What Samba should do with logins that do not match Unix users'

property :realm,
        String,
        description: 'Kerberos realm to use'

property :kerberos_method,
        String,
        default: 'secrets only',
        equal_to: ['secrets only', 'system keytab', 'dedicated keytab', 'secrets and keytab'],
        description: 'How kerberos tickets are verified'

property :password_server,
        String,
        default: '*',
        description: 'Use a specific remote server for auth'

property :encrypt_passwords,
        [true, false],
        default: true,
        coerce: proc { |p| p ? 'yes' : 'no' },
        description: 'Whether to negotiate encrypted passwords'

property :log_level,
        String, Integer,
        default: '0',
        coerce: proc { |p| p.is_a?(Integer) ? p.to_s : p },
        description: 'Sets the logging level from 0-10'

property :winbind_separator,
        String,
        default: '\\',
        description: 'the character used when listing a username of the form of DOMAIN \user'

property :idmap_config,
        String,
        description: 'Define the mapping between SIDS and Unix users and groups'

property :socket_options,
        [String, Integer],
        default: '`TCP_NODELAY`',
        equal_to: %w(SO_KEEPALIV SO_REUSEADDR SO_BROADCAST TCP_NODELAY IPTOS_LOWDELAY IPTOS_THROUGHPUT SO_SNDBUF SO_RCVBUF SO_SNDLOWAT SO_RCVLOWAT),
        description: 'Options for connection tuning'

property :log_dir,
        String,
        default: lazy { platform_family?('rhel', 'fedora', 'amazon', 'suse') ? '/var/log/samba/log.%m' : '/var/log/samba/%m.log' },
        description: 'Location of Samba logs'

property :max_log_size,
        [String, Integer],
        default: '5000',
        description: 'Maximum log file size'

property :options,
        Hash,
        default: {},
        description: 'Hash of additional options'

property :config_file,
        String,
        default: '/etc/samba/smb.conf',
        description: 'Location of Samba configuration'

property :samba_services,
        Array,
        default: lazy { platform_family?('rhel', 'fedora', 'amazon', 'suse') ? %w(smb nmb) : %w(smbd nmbd) },
        description: 'An array of services to start'

action :create do
  package 'samba'

  # We need to force both the server template and the
  # share templates into the root context to find each other
  with_run_context :root do
    template new_resource.config_file do
      source 'smb.conf.erb'
      owner 'root'
      group 'root'
      mode '0644'
      cookbook 'samba'
      variables(
        idmap_config: new_resource.idmap_config,
        winbind_separator: new_resource.winbind_separator,
        kerberos_method: new_resource.kerberos_method,
        encrypt_passwords: new_resource.encrypt_passwords,
        password_server: new_resource.password_server,
        realm: new_resource.realm,
        workgroup: new_resource.workgroup,
        server_string: new_resource.server_string,
        security: new_resource.security,
        map_to_guest: new_resource.map_to_guest,
        interfaces: new_resource.interfaces,
        hosts_allow: new_resource.hosts_allow,
        load_printers: new_resource.load_printers,
        passdb_backend: new_resource.passdb_backend,
        dns_proxy: new_resource.dns_proxy,
        samba_options: new_resource.options,
        log_level: new_resource.log_level,
        max_log_size: new_resource.max_log_size,
        bind_interfaces_only: new_resource.bind_interfaces_only
      )
      new_resource.samba_services.each do |samba_service|
        notifies :restart, "service[#{samba_service}]", :delayed
        notifies :enable, "service[#{samba_service}]", :delayed
      end

      action :nothing
      delayed_action :create
    end

    new_resource.samba_services.each do |s|
      service s do
        supports restart: true, reload: true
        action :nothing
      end
    end
  end
end
