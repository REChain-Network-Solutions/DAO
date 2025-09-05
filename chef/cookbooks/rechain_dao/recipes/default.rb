# REChain DAO Platform Chef Cookbook
# Default recipe for setting up the REChain DAO Platform

# Update package lists
apt_update 'update package lists' do
  action :update
end

# Install required packages
package %w(
  curl
  wget
  git
  unzip
  software-properties-common
  apt-transport-https
  ca-certificates
  gnupg
  lsb-release
) do
  action :install
end

# Create application user
user node['rechain_dao']['user'] do
  system true
  shell '/bin/bash'
  home node['rechain_dao']['home']
  manage_home true
end

# Create application group
group node['rechain_dao']['group'] do
  members node['rechain_dao']['user']
  action :create
end

# Create application directories
[
  node['rechain_dao']['home'],
  node['rechain_dao']['log_dir'],
  node['rechain_dao']['data_dir'],
  node['rechain_dao']['config_dir'],
  node['rechain_dao']['backup_dir']
].each do |dir|
  directory dir do
    owner node['rechain_dao']['user']
    group node['rechain_dao']['group']
    mode '0755'
    recursive true
    action :create
  end
end

# Install Node.js
include_recipe 'rechain_dao::nodejs'

# Install PM2
include_recipe 'rechain_dao::pm2'

# Install and configure Nginx
include_recipe 'rechain_dao::nginx'

# Install and configure MySQL
include_recipe 'rechain_dao::mysql'

# Install and configure Redis
include_recipe 'rechain_dao::redis'

# Configure SSL certificates
include_recipe 'rechain_dao::ssl'

# Setup monitoring
include_recipe 'rechain_dao::monitoring'

# Configure logging
include_recipe 'rechain_dao::logging'

# Setup backup
include_recipe 'rechain_dao::backup'

# Configure firewall
include_recipe 'rechain_dao::firewall'

# Deploy application
include_recipe 'rechain_dao::deploy'

# Start services
include_recipe 'rechain_dao::services'
