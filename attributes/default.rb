# Copyright 2015 Nordstrom, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['chefdk_bootstrap']['atom']['source_url'] =
value_for_platform_family(
  'mac_os_x' => 'https://atom.io/download/mac',
  'windows' => 'https://atom.io/download/windows',
  'ubuntu' => 'https://atom.io/download/ubuntu'
)

# common things to install
default['chefdk_bootstrap']['package'].tap do |install|
  install['atom'] = true
  install['virtualbox'] = true
  install['vagrant'] = true
  install['git'] = true
  install['chefdk_julia'] = false
  install['kitchen_proxy'] = true
end

# platform specific
case node['platform']
when 'windows'
  default['chefdk_bootstrap']['package'].tap do |install|
    install['kdiff3'] = true
    install['gitextensions'] = true
    install['poshgit'] = true
    install['conemu'] = true
    install['cygwin'] = true
  end
  default['vagrant']['msi_version'] = '1.9.1'
  default['vagrant']['url']         = 'https://releases.hashicorp.com/vagrant/1.9.1/vagrant_1.9.1.msi'
  default['vagrant']['checksum']    = 'db1fef59dd15ac90b6f5cfad20af7e15eccd814556a81f46e5422386166789a6'  
when 'mac_os_x'
  default['chefdk_bootstrap']['package'].tap do |install|
    install['iterm2'] = true
    install['bash_profile'] = true
  end
  default['chefdk_bootstrap']['virtualbox']['source'] = 'http://download.virtualbox.org/virtualbox/5.1.14/VirtualBox-5.1.14-112924-OSX.dmg'
  default['chefdk_bootstrap']['virtualbox']['checksum'] = 'f12ed3b1f98c45074e52742d1006c418acd22d0d91e8a6fb6f7b3121c21ce998'  
when 'ubuntu'
  default['vagrant']['version'] = '1.9.1'
  default['vagrant']['url']         = 'https://releases.hashicorp.com/vagrant/1.9.1/vagrant_1.9.1_x86_64.deb'
  default['vagrant']['checksum']    = 'd006d6227e049725b64d8ba3967f0c82460a403ff40230515c93134d58723150'
  default['chefdk_bootstrap']['virtualbox']['source'] = 'http://download.virtualbox.org/virtualbox/5.1.14/virtualbox-5.1_5.1.14-112924~Ubuntu~xenial_amd64.deb'
  default['chefdk_bootstrap']['virtualbox']['checksum'] = '61bd2e0b702e80c6f9b61e900a7cd6b773ca03cdf1de1439241ec126a518fdce'
  default['chefdk_bootstrap']['virtualbox']['version'] = '5.1'
end

# whether to mess with PowerShell settings
default['chefdk_bootstrap']['powershell']['configure'] = true

# Enable cmd line tools like git, curl, Stove to work through a proxy server.
# Override these to set http_proxy, https_proxy, and no_proxy env vars
default['chefdk_bootstrap']['proxy']['http'] = ENV['http_proxy'] # 'http://myproxy.example.com:1234'
# Skip the proxy for these domains and IPs. This should be a comma-separated string
default['chefdk_bootstrap']['proxy']['no_proxy'] = ENV['no_proxy'] # 'example.com,localhost,127.0.0.1'
