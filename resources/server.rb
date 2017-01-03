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
default_action :create

property :workgroup, String, default: 'SAMBA'
property :interfaces, String, default: 'lo 127.0.0.1'
property :hosts_allow, String, default: '127.0.0.0/8'
property :bind_interfaces_only, String, default: 'no', equal_to: ['yes', 'no']
property :server_string, String, default: 'Samba Server'
property :load_printers, String, default: 'no', equal_to: ['yes', 'no']
property :passdb_backend, String, default: 'tdbsam', equal_to: ['ldapsam','tdbsam','smbpasswd']
property :dns_proxy, String, default: 'no', default: 'no', equal_to: ['yes', 'no']
property :security, String, default: 'user', equal_to: ['user','domain','ADS','share','server'] # https://www.samba.org/samba/docs/man/Samba-HOWTO-Collection/ServerType.html
property :map_to_guest, String, default: 'Bad User'
property :socket_options, String, default: '`TCP_NODELAY`'
property :log_dir, String, default: lazy {
  case node['platform_family']
  when 'smartos', 'arch', 'rhel', 'fedora'
    '/var/log/samba/log.%m'
  when 'debian'
    'var/log/samba/%m.log'
  else
    '/var/log/samba/%m.log'
  end
}
property :max_log_size, String, default: '5000' #5M
property :options, [String, nil], default: ''
property :enable_users_search, [TrueClass, FalseClass], default: true
property :config_file, String, default: lazy {
  if node['platform_family'] = 'smartos'
    '/opt/local/etc/samba/smb.conf'
  else
    '/etc/samba/smb.conf'
  end
}
property :samba_services, Array, default: lazy {
  case node['platform']
  when 'smartos', 'ubuntu', 'linuxmint'
    %w(smbd nmbd)
  when 'arch', 'debian'
    ['samba']
  when 'rhel', 'fedora'
    %w(smb, nmb)
  else
    %w(smbd nmbd)
}

action :create do
  package 'samba'

  template config_file do
    source 'smb.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      workgroup: new_resource.workgroup
      server_string: new_resource.server_string
      security: new_resource.security
      map_to_guest: new_resource.map_to_guests
      interfaces: new_resource.interfaces
      hosts_allow: new_resource.hosts_allow
      load_printers: new_resource.load_printers
      passdb_backend: new_resource.passdb_backend
      dns_proxy: new_resource.dns_proxy
      samba_options: new_resource.options
      shares: new_resource.shares
    )
    samba_services.each do |samba_service|
      notifies :restart, "service[#{samba_service}]"
  end
end
