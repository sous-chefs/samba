#
# Cookbook:: samba
# Resource:: share
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
property :share_name, String, name_property: true
property :comment, String
property :path, String, required: true
property :guest_ok, String, default: 'no', equal_to: %w(yes no)
property :printable, String, default: 'no', equal_to: %w(yes no)
property :write_list, Array, required: true # e.g. %w(jtimberman damacus)
property :create_mask, String, required: true # e.g. 0644
property :directory_mask, String, required: true # e.g. 0700
property :create_directory, [TrueClass, FalseClass], default: true
property :config_file, String, default: lazy {
  if node['platform_family'] == 'smartos'
    '/opt/local/etc/samba/smb.conf'
  else
    '/etc/samba/smb.conf'
  end
}

action :add do
  # We need to force both the server template and the
  # share templates into the root context to find each other
  with_run_context :root do
    edit_resource!(:template, '/etc/samba/smb.conf') do |new_resource|
      cookbook 'samba'
      variables[:shares] ||= {}
      variables[:shares][new_resource.share_name] ||= {}
      variables[:shares][new_resource.share_name]['comment'] = new_resource.comment
      variables[:shares][new_resource.share_name]['path'] = new_resource.path
      variables[:shares][new_resource.share_name]['guest ok'] = new_resource.guest_ok
      variables[:shares][new_resource.share_name]['printable'] = new_resource.printable
      variables[:shares][new_resource.share_name]['write list'] = new_resource.write_list
      variables[:shares][new_resource.share_name]['create mask'] = new_resource.create_mask
      variables[:shares][new_resource.share_name]['directory mask'] = new_resource.directory_mask

      action :nothing
      delayed_action :create
    end
  end

  directory path do
    recursive true
    only_if { create_directory == true }
  end
end
