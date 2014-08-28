#
# Cookbook Name:: chef-splunk-windows
# Attributes:: domaincontroller_ta
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

# A path to the Splunk App for Windows Infrastructure file must be provided; the file must be in zip format
default['splunk']['domaincontroller_ta']['infrastructure_app_url'] = 'http://download.contoso.com/splunk/splunk-app-for-windows-infrastructure_102.zip'
# If using Windows Server 2012 R2 the PowerShell addon file must be provided; the file must be in zip format
default['splunk']['domaincontroller_ta']['powershell_addon_url'] = 'http://download.contoso.com/splunk/splunk-addon-for-microsoft-powershell_11.zip'