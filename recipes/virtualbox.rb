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

case node['platform']
when 'windows'
  chocolatey_package 'virtualbox' do
    options '--allow-empty-checksums --version 5.1.14 -y'
  end
when 'mac_os_x'
  dmg_package 'Virtualbox' do
    source node['chefdk_bootstrap']['virtualbox']['source']
    checksum node['chefdk_bootstrap']['virtualbox']['checksum']
    type 'pkg'
  end
when 'ubuntu'
  apt_repository 'virtualboxrepo' do
    uri 'http://download.virtualbox.org/virtualbox/debian'
    key ['http://download.virtualbox.org/virtualbox/debian/oracle_vbox_2016.asc', 'https://www.virtualbox.org/download/oracle_vbox.asc']
    distribution 'xenial contrib non-free'
    action :add
  end
  apt_update 'virtualboxrepo' do
    action :update
  end
  apt_package 'virtualbox-5.1' do
    action :install
  end
end
