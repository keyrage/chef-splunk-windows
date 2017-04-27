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
ver = '6.5.3'
build = '36937ad027d4'
arch = case node['kernel']['machine']
       when 'x86_64'
         'x64'
       else
         'x86'
       end
default['splunk']['forwarder']['url'] = 'http://download.splunk.com/releases/'\
                                        "#{ver}/universalforwarder/windows/"\
                                        "splunkforwarder-#{ver}-#{build}-"\
                                        "#{arch}-release.msi"

default['splunk']['forwarder']['home'] =
  'C:\Program Files\SplunkUniversalForwarder'
default['splunk']['forwarder']['installer_flags'] = [
  "INSTALLDIR=\"#{node['splunk']['forwarder']['home']}\""
]
