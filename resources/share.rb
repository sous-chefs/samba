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

attribute :name, String, name_property: true
attribute :comment, String
attribute :path, String, required: true
attribute :guest_ok, String, default: 'no', equal_to: ['yes','no']
attribute :printable, String, default: 'no', equal_to: ['yes','no']
attribute :write_list, Array, required: true  # e.g. ['jtimerman','damacus']
attribute :create_mask, String, required: true, regex: [] # e.g. 0644
attribute :directory_mask, String, required: true, regex: []

action :add do

end
