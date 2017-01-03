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

default_action :add
resource_name :samba_share

property :name, String, name_property: true
property :comment, String
property :path, String, required: true
property :guest_ok, String, default: 'no', equal_to: ['yes','no']
property :printable, String, default: 'no', equal_to: ['yes','no']
property :write_list, Array, required: true  # e.g. ['jtimerman','damacus']
property :create_mask, String, required: true, regex: [] # e.g. 0644
property :directory_mask, String, required: true, regex: []
property :config_file, String, default: lazy {
  if node['platform_family'] = 'smartos'
    '/opt/local/etc/samba/smb.conf'
  else
    '/etc/samba/smb.conf'
  end
}

action :add do
  with_run_context :root do
    edit_resource(:template, config_file) do |new_resource|
      source 'smb.conf.erb'
      variables[:shares] ||= {}
      variables[:shares][new_resource.name] ||= []
      variables[:shares][new_resource.name] += new_resource.name

      variables[:shares][new_resource.name] ||= []
      variables[:shares][new_resource.name] += new_resource.comment
      variables[:shares][new_resource.name] ||= []
      variables[:shares][new_resource.name] += new_resource.path
      variables[:shares][new_resource.name] ||= []
      variables[:shares][new_resource.name] += new_resource.guest_ok
      variables[:shares][new_resource.name] ||= []
      variables[:shares][new_resource.name] += new_resource.printable
      variables[:shares][new_resource.name] ||= []
      variables[:shares][new_resource.name] += new_resource.write_list
      variables[:shares][new_resource.name] ||= []
      variables[:shares][new_resource.name] += new_resource.create_mask
      variables[:shares][new_resource.name] ||= []
      variables[:shares][new_resource.name] += new_resource.directory_mask

      action :nothing
      delayed_action :create
    end
  end
end
