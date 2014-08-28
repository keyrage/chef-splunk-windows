# chef-splunk-windows-cookbook

This cookbook installs and configures a Splunk universal forwarder on a Windows server. It is intended to complement the chef-splunk cookbook: https://supermarket.getchef.com/cookbooks/chef-splunk.

## Supported Platforms

Windows Server 2003 and above. PowerShell is required for the windows_ta and domaincontroller_ta recipes.

## Usage

### chef-splunk-windows::default

Include `chef-splunk-windows` in your node's `run_list` along with any relevant attributes:

```json
{
  "default_attributes": {
    "splunk": {
      "accept_license": true
    }
  },
  "run_list": [
    "recipe[chef-splunk-windows::default]"
  ]
}
```

License and Authors
-------------------
- Author:: Jared King <jared.king@biola.edu>

```text
Copyright 2014, Biola University

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```