# chef-splunk-windows-cookbook

This cookbook installs and configures a Splunk universal forwarder on a Windows server. It is intended to complement the chef-splunk cookbook: https://supermarket.getchef.com/cookbooks/chef-splunk.

## Supported Platforms

Windows Server 2003 and above. PowerShell is required for the domaincontroller_ta recipe.

## Usage

### chef-splunk-windows::default

1. Indicate your acceptence of the Splunk license by adding `['splunk']['accept_license'] = 'true'` to your node's attributes
2. Include `chef-splunk-windows` in your node's `run_list` along with any other relevant attributes:

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

### chef-splunk-windows::windows_ta

1. Upload the Windows Technology Add-on installer to your local webserver and update your node's attributes (noted below) to reflect your URL & SHA-256 checksum.
3. Include `chef-splunk-windows::windows_ta` in your node's `run_list` along with any other relevant attributes:

```json
{
  "default_attributes": {
    "splunk": {
      "windows_ta": {
        "checksum": "SHA256CHECKSUMHERE",
        "url": "http://example.server.internal/splunkwindowstainstaller.zip"
      }
    }
  },
  "run_list": [
    "recipe[chef-splunk-windows::default]",
    "recipe[chef-splunk-windows::windows_ta]"
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
