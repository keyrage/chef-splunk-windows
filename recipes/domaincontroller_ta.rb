#
# Cookbook Name:: chef-splunk-windows
# Recipe:: domaincontroller_ta
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
  # Determine the TA version to install
  ta_version = ''
  if node["platform_version"] < "6.3"
    ta_version = "NT6"
  else
    ta_version = "2012R2"

    # Deploy the PowerShell addon for Server 2012 R2 hosts
    # Download the addon from the URL specified
    ta_file = node['splunk']['domaincontroller_ta']['powershell_addon_url'].split('/').last
    remote_file "#{Chef::Config[:file_cache_path]}/#{ta_file}" do 
      source node['splunk']['domaincontroller_ta']['powershell_addon_url']
      notifies :run, 'powershell_script[Extract PowerShell Addon]'
    end

    # Extract the addon file
    powershell_script "Extract PowerShell Addon" do
      code <<-EOH
      $shell = New-Object -com shell.application
      $zip_file = $shell.NameSpace("#{Chef::Config[:file_cache_path]}\\#{ta_file}")
      $destination = $shell.NameSpace("#{node['splunk']['forwarder']['home']}\\etc\\apps")
      $destination.CopyHere($zip_file.items(), 0x14)
      EOH
      action :nothing
    end
  end

  # Download the app from the URL specified
  ta_file = node['splunk']['domaincontroller_ta']['infrastructure_app_url'].split('/').last
  remote_file "#{Chef::Config[:file_cache_path]}/#{ta_file}" do 
    source node['splunk']['domaincontroller_ta']['infrastructure_app_url']
    notifies :run, 'powershell_script[Install Domain Controller TA]'
  end

  # Extract the app file and install the appropriate TA
  powershell_script "Install Domain Controller TA" do
    code <<-EOH
    $shell = New-Object -com shell.application
    $zip_file = $shell.NameSpace("#{Chef::Config[:file_cache_path]}\\#{ta_file}")
    $destination = $shell.NameSpace("#{Chef::Config[:file_cache_path]}")
    $destination.CopyHere($zip_file.items(), 0x14)
    Copy-Item "#{Chef::Config[:file_cache_path]}\\splunk_app_windows_infrastructure\\appserver\\addons\\TA-DomainController-#{ta_version}" "#{node['splunk']['forwarder']['home']}\\etc\\apps" -Force -Recurse
    EOH
    action :nothing
  end

  if File.directory?("#{node['splunk']['forwarder']['home']}/etc/apps/TA-DomainController-#{ta_version}")
    # Create a local directory
    directory "#{node['splunk']['forwarder']['home']}/etc/apps/TA-DomainController-#{ta_version}/local" do
      inherits true
      action :create
    end

    # Configure the inputs file
    template "#{node['splunk']['forwarder']['home']}/etc/apps/TA-DomainController-#{ta_version}/local/inputs.conf" do
      source 'domaincontroller_ta_inputs.conf.erb'
      variables({
        :ta_version => ta_version
      })
      notifies :restart, 'service[SplunkForwarder]'
    end
  end
end