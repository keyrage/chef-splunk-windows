#
# Cookbook Name:: chef-splunk-windows
# Attributes:: default
#
# Copyright 2014, Biola University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE_2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['splunk']['accept_license'] = false
default['splunk']['receiver_port'] = '9997'

if node['kernel']['machine'] == 'x86_64'
  default['splunk']['forwarder']['url'] = 'http://download.splunk.com/releases/6.1.3/universalforwarder/windows/splunkforwarder-6.1.3-220630-x64-release.msi'
else
  default['splunk']['forwarder']['url'] = 'http://download.splunk.com/releases/6.1.3/universalforwarder/windows/splunkforwarder-6.1.3-220630-x86-release.msi'
end

default['splunk']['forwarder']['home'] = 'C:\Program Files\SplunkUniversalForwarder'
default['splunk']['forwarder']['installer_flags'] = [
  "INSTALLDIR=\"#{node['splunk']['forwarder']['home']}\""
]