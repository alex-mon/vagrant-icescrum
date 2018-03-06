# Default jre will suffice
package { 'default-jre': ensure => 'installed' }

# User to run IceScrum
user { 'icescrum':
  ensure      => 'present',
  comment     => 'IceScrum',
  groups      => ['sudo'],
  home        => '/home/icescrum',
  shell       => '/bin/bash',
  managehome  => yes,
  password    => '$1$4lR2uQ/E$Ogl5Mew16ksejRzkf5gbc/', #Hash for: Jfr3y89h
}

# Create IceScrum's directory
file { '/home/icescrum/icescrum':
  ensure => 'directory',
  owner  => 'icescrum'
}

# Create IceScrum's launch script
file { '/home/icescrum/icescrum/launch.sh':
  content => 'java -Xmx1024M -XX:MaxPermSize=256m -Dicescrum_config_location=/home/icescrum/icescrum/config.groovy -jar icescrum.jar host=0.0.0.0',
  ensure  => present,
  mode    => 744,
  owner   => 'icescrum',
}

# Download IceScrum release
exec { 'get-icescrum-jar-file':
  command => '/usr/bin/wget https://www.icescrum.com/downloads/v7/icescrum.jar',
  cwd     => '/home/icescrum/icescrum',
  creates => '/home/icescrum/icescrum.jar',
  user    => 'icescrum',
}

# Install mysql
class { '::mysql::server':
}

# Create db for IceScrum
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
