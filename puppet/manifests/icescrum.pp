
package { 'default-jre': ensure => 'installed' }

user { 'icescrum':
  ensure  => 'present',
  comment => 'IceScrum',
  groups  => ['sudo'],
  home    => '/home/icescrum',
  shell   => '/bin/bash',
  managehome => yes,
  password => '$1$4lR2uQ/E$Ogl5Mew16ksejRzkf5gbc/',
}

# Create app's directory
file { '/home/icescrum/icescrum':
  ensure => 'directory',
}

# Create app's launch script
file { '/home/icescrum/icescrum/launch.sh':
  content => 'java -Xmx1024M -XX:MaxPermSize=256m -Dicescrum_config_location=/home/icescrum/icescrum/config.groovy -jar icescrum.jar host=192.168.20.10',
  ensure => present,
  mode => 777,
}

# Download icescrum release
exec { 'get-icescrum-jar-file':
  command => '/usr/bin/wget https://www.icescrum.com/downloads/v7/icescrum.jar',
  cwd     => '/home/icescrum/icescrum',
  creates => '/home/icescrum/icescrum.jar',
  user    => root
}

# Install mysql
class { '::mysql::server':
}

mysql::db { 'icescrum':
  user     => 'icescrum',
  password => 'Jfr3y89h',
  host     => '%',
  grant    => ['ALL PRIVILEGES'],
}

# Install postfix 
include postfix
postfix::config { 'relay_domains':
  ensure  => present,
  value   => 'localhost host.foo.com',
}
