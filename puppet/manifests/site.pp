# Puppet manifest for REChain DAO Platform
# This manifest defines the complete infrastructure setup

# Global variables
$app_name = 'rechain-dao'
$app_user = 'rechain'
$app_group = 'rechain'
$app_home = '/opt/rechain-dao'
$app_port = 3000
$db_name = 'rechain_dao'
$db_user = 'rechain_user'
$redis_port = 6379

# Node definitions
node 'web-server-01' {
  include rechain_dao::web
  include rechain_dao::nginx
  include rechain_dao::ssl
}

node 'app-server-01', 'app-server-02' {
  include rechain_dao::app
  include rechain_dao::nodejs
  include rechain_dao::pm2
}

node 'db-server-01' {
  include rechain_dao::database
  include rechain_dao::mysql
  include rechain_dao::backup
}

node 'cache-server-01' {
  include rechain_dao::redis
  include rechain_dao::monitoring
}

node 'monitoring-server-01' {
  include rechain_dao::monitoring
  include rechain_dao::prometheus
  include rechain_dao::grafana
}

# Default node configuration
node default {
  include rechain_dao::base
  include rechain_dao::security
  include rechain_dao::logging
}
