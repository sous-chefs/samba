#
# Cookbook Name:: samba
# Recipe:: default
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
#

shares = data_bag_item(node['samba']['shares_data_bag'], 'shares')

shares['shares'].each do |k, v|
  if v.key?('path') # ~FC023
    directory v['path'] do
      recursive true
    end
  end
end

users = if node["samba"]["passdb_backend"] !=~ /^ldapsam/ && node['samba']['enable_users_search']
  search(node['samba']['users_data_bag'], '*:*') # ~FC003
end

package node['samba']['server_package']
svcs = node['samba']['services']

template node['samba']['config'] do
  source 'smb.conf.erb'
  owner 'root'
  group 'root'
  mode 00644
  variables :shares => shares['shares']
  svcs.each do |s|
    notifies :restart, "service[#{s}]"
  end
end

if users
  users.each do |u|
    next unless u['smbpasswd']
    samba_user u['id'] do
      password u['smbpasswd']
      action [:create, :enable]
    end
  end
end

svcs.each do |s|
  service s do
    supports :restart => true, :reload => true
    provider Chef::Provider::Service::Upstart if platform?('ubuntu') && node['platform_version'].to_f == 14.04
    pattern 'smbd|nmbd' if node['platform'] =~ /^arch$/
    action [:enable, :start]
  end
end
