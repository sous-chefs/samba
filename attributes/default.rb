#
# Cookbook Name:: samba
# Attributes:: default
#
# Copyright 2010, Opscode, Inc.
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

default['samba']['workgroup'] = 'SAMBA'
default['samba']['interfaces'] = 'lo 127.0.0.1'
default['samba']['hosts_allow'] = '127.0.0.0/8'
default['samba']['bind_interfaces_only'] = 'no'
default['samba']['server_string'] = 'Samba Server'
default['samba']['load_printers'] = 'no'
default['samba']['passdb_backend'] = 'tdbsam'
default['samba']['dns_proxy'] = 'no'
default['samba']['security'] = 'user'
default['samba']['map_to_guest'] = 'Bad User'
default['samba']['socket_options'] = 'TCP_NODELAY'
default['samba']['shares_data_bag'] = 'samba'
default['samba']['users_data_bag'] = 'users'

# Samba client package defaults
case platform
when 'arch'
  default['samba']['client_package'] = 'smbclient'
when 'redhat', 'centos', 'fedora', 'scientific', 'amazon'
  default['samba']['client_package'] = 'samba-client'
else
  default['samba']['client_package'] = 'smbclient'
end

# Samba server package defaults
case platform
when 'ubuntu', 'debian', 'arch'
  default['samba']['server_package'] = 'samba'
when 'redhat', 'centos', 'fedora', 'scientific', 'amazon'
  default['samba']['server_package'] = 'samba'
else
  default['samba']['server_package'] = 'samba'
end

# Samba service name defaults
case platform
when 'ubuntu'
  default['samba']['services'] = ['smbd', 'nmbd']
when 'redhat', 'centos', 'fedora', 'scientific', 'amazon'
  default['samba']['services'] = ['smb', 'nmb']
when 'arch', 'debian', 'raspbian'
  default['samba']['services'] = ['samba']
else
  default['samba']['services'] = ['smbd', 'nmbd']
end

case platform
when 'arch'
  set['samba']['config'] = '/etc/samba/smb.conf'
  set['samba']['log_dir'] = '/var/log/samba/log.%m'
when 'redhat', 'centos', 'fedora', 'amazon', 'scientific'
  set['samba']['config'] = '/etc/samba/smb.conf'
  set['samba']['log_dir'] = '/var/log/samba/log.%m'
else
  set['samba']['config'] = '/etc/samba/smb.conf'
  set['samba']['log_dir'] = '/var/log/samba/%m.log'
end
