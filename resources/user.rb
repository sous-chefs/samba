#
# Cookbook:: samba
# Resource:: user
#
# Copyright:: 2010-2017, Chef Software, Inc <legalchef.io>
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
property :name, String, name_property: true
property :password, String
property :exists, [TrueClass, FalseClass], default: false
property :disabled, [TrueClass, FalseClass], default: false
property :comment, String
property :home, String, default: lazy { ::File.join('/home/', name) }
property :shell, String, default: '/bin/bash'

def load_current_value
  @smbuser = Chef::Resource::SambaUser.new(new_resource.name)

  Chef::Log.debug("Checking for smbuser #{new_resource.name}")
  u = Mixlib::ShellOut.new("pdbedit -Lv -u #{new_resource.name}")
  u.run_command
  exists = u.stdout.include?(new_resource.name)
  disabled = u.stdout.include?('Account Flags.*[D')
  @smbuser.exists(exists)
  @smbuser.disabled(disabled)
end

action :create do
  user new_resource.name do
    password new_resource.password
    comment new_resource.comment
    home new_resource.home
    shell new_resource.shell
    notifies :run, "execute[Create samba user #{new_resource.name}]", :immediately
  end

  group new_resource.name do
    members new_resource.name
    action :create
  end

  directory new_resource.home do
    group new_resource.name
    user new_resource.name
  end

  passwd = new_resource.password
  execute "Create samba user #{new_resource.name}" do
    command "echo '#{passwd}\n#{passwd}' | smbpasswd -s -a #{new_resource.name}"
    action :nothing
  end
end

action :enable do
  execute "Enable #{new_resource.name}" do
    command "smbpasswd -e #{new_resource.name}"
    only_if { @smbuser.disabled }
  end
end

action :delete do
  if @smbuser.exists
    execute "Delete #{new_resource.name}" do
      command "smbpasswd -x #{new_resource.name}"
    end
    new_resource.updated_by_last_action(true)
  end
end
