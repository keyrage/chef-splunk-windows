#
# Cookbook Name:: chef-splunk-windows
# Recipe:: windows_ta
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

# Needed for zip actions below
include_recipe 'windows::default'

service "SplunkForwarder" do
  action :nothing
  supports :restart => true
end

# If the universal forwarder has been installed and the local TA URL specified, proceed
if File.directory?("#{node['splunk']['forwarder']['home']}/etc/apps") and (not node['splunk']['windows_ta']['url'].include?('download.contoso.com'))
  # Deploy the TA file
  windows_zipfile "#{node['splunk']['forwarder']['home']}/etc/apps" do
    source node['splunk']['windows_ta']['url']
    checksum node['splunk']['windows_ta']['checksum']
    action :unzip
    not_if {::File.directory?("#{node['splunk']['forwarder']['home']}/etc/apps/Splunk_TA_windows")}
  end
  
  if File.directory?("#{node['splunk']['forwarder']['home']}/etc/apps/Splunk_TA_windows")
    # Create a local directory
    directory "#{node['splunk']['forwarder']['home']}/etc/apps/Splunk_TA_windows/local" do
      inherits true
      action :create
    end
    
    # Configure the inputs file
    template "#{node['splunk']['forwarder']['home']}/etc/apps/Splunk_TA_windows/local/inputs.conf" do
      source 'windows_ta_inputs.conf.erb'
      notifies :restart, 'service[SplunkForwarder]'
    end
  end
else
  log "Splunk not installed or local TA URL not defined"
end
