#
# Cookbook Name:: chef-splunk-windows
# Recipe:: client
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

splunk_servers = search(
  :node,
  "splunk_is_server:true AND chef_environment:#{node.chef_environment}"
).sort! do
  |a, b| a.name <=> b.name
end

service "SplunkForwarder" do
  action :nothing
  supports :restart => true
end

if node['splunk']['accept_license']
  windows_package "UniversalForwarder" do
    source node['splunk']['forwarder']['url']
    options node['splunk']['forwarder']['installer_flags'].join(' ') + " AGREETOLICENSE=Yes /quiet /norestart" 
    action :install
  end

  template "#{node['splunk']['forwarder']['home']}/etc/system/local/outputs.conf" do
    source 'outputs.conf.erb'
    variables :splunk_servers => splunk_servers
    notifies :restart, 'service[SplunkForwarder]'
  end

  include_recipe 'chef-splunk-windows::setup_auth'
else
  Chef::Log.debug('The Splunk license has not been accepted. Skipping installation.')
end