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

service "SplunkForwarder" do
  action :nothing
  supports :restart => true
end

if File.directory?("#{node['splunk']['forwarder']['home']}/etc/apps")
  # Download the TA from the URL specified
  ta_file = node['splunk']['windows_ta']['url'].split('/').last
  remote_file "#{Chef::Config[:file_cache_path]}/#{ta_file}" do 
    source node['splunk']['windows_ta']['url']
    notifies :run, 'powershell_script[Extract Windows TA]'
  end

  # Extract the TA file
  powershell_script "Extract Windows TA" do
    code <<-EOH
    $shell = New-Object -com shell.application
    $zip_file = $shell.NameSpace("#{Chef::Config[:file_cache_path]}\\#{ta_file}")
    $destination = $shell.NameSpace("#{node['splunk']['forwarder']['home']}\\etc\\apps")
    $destination.CopyHere($zip_file.items(), 0x14)
    EOH
    action :nothing
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
end