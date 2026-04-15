# frozen_string_literal: true

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

unified_mode true

samba_yes_no = proc do |value|
  case value
  when String
    value.casecmp('yes').zero? || value.casecmp('true').zero? ? 'yes' : 'no'
  else
    value ? 'yes' : 'no'
  end
end

property :share_name,
        String,
        name_property: true,
        description: 'The name of the share'

property :comment,
        String,
        description: 'Comment string to associate with the new share'

property :path,
        String,
        required: false,
        description: 'Path to directory to share'

property :valid_users,
        String,
        description: 'A string of allowed users'

property :force_group,
        String,
        description: 'Force ownership of files on the share to specified group'

property :force_user,
        String,
        description: 'Force ownership of files on the share to specified user'

property :browseable,
        [true, false, String],
        default: true,
        coerce: samba_yes_no,
        description: 'Controls whether this share is seen in the list of available shares in a net view and in the browse list'

property :guest_ok,
        [true, false, String],
        default: false,
        coerce: samba_yes_no,
        description: 'Allow anoymous access to the share'

property :printable,
        [true, false, String],
        default: false,
        coerce: samba_yes_no,
        description: 'If set to yes, then clients may open, write to and submit spool files on the directory specified for the service'

property :write_list,
        Array,
        required: false,
        description: 'An array of Unix users allowed to write to the share'

property :create_mask,
        String,
        default: '0744',
        required: false,
        description: 'Create mask for directory'

property :directory_mask,
        String,
        default: '0755',
        required: false,
        description: 'Mask for directory'

property :read_only,
        [true, false, String],
        default: false,
        coerce: samba_yes_no,
        description: 'Whether files on the share are writeable'

property :create_directory,
        [true, false, String],
        default: true,
        description: 'Whether to create the new share directory on disk'

property :options,
        Hash,
        default: {},
        description: 'A hash of extra options to pass to the configuration file'

property :config_file,
        String,
        default: lazy { platform?('smartos') ? '/opt/local/etc/samba/smb.conf' : '/etc/samba/smb.conf' },
        description: 'Path to the samba configuration file'

action :add do
  if new_resource.create_directory
    directory new_resource.path do
      recursive true
    end
  end
end
