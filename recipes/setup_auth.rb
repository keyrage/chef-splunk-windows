#
# Cookbook Name:: chef-splunk-windows
# Recipe:: setup_auth
#
# Copyright 2014, Biola University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'chef-vault'

splunk_auth_info = chef_vault_item(:vault, "splunk_#{node.chef_environment}")['auth']
user, pw = splunk_auth_info.split(':')

execute 'change-admin-user-password-from-default' do
  command "\"#{node['splunk']['forwarder']['home']}/bin/splunk.exe\" edit user #{user} -password '#{pw}' -role admin -auth admin:changeme"
  not_if { ::File.exist?("#{node['splunk']['forwarder']['home']}/etc/.setup_#{user}_password") }
end

file "#{node['splunk']['forwarder']['home']}/etc/.setup_#{user}_password" do
  content 'true'
end
