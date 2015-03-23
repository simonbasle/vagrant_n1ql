# ===
# Install and Run Couchbase Server
# ===

file { "vagrantmount1":
    path => "/vagrant/prov",
    ensure => "directory",
    before => Exec["couchbase-server-source"]
}

file { "vagrantmount2":
    path => "/vagrant/resources",
    ensure => "directory",
    before => Exec["couchbase-server-source"]
}

$fullUrl = $cburl
$splitter = split($fullUrl, '/')
$filename = $splitter[-1]

# Download the Sources
exec { "couchbase-server-source":
    command => "/usr/bin/wget $fullUrl",
    cwd => "/vagrant/prov",
    creates => "/vagrant/prov/$filename",
    before => Package['couchbase-server'],
    timeout => 1200
}

$n1qlsplitter = split($n1qlurl, '/')
$n1qlarchive = $n1qlsplitter[-1]


exec { "puppet-setpassword":
    command => "/usr/bin/apt-get install make && /opt/vagrant_ruby/bin/gem install ruby-shadow --no-ri",
    cwd => "/vagrant/prov",
    timeout => 1200,
    before => File["cbqhome"]
}

file { "cbqhome":
    path => "/home/cbq",
    before => User["cbq"]
}

user { "cbq":
    name => "cbq",
    ensure => 'present',
    managehome => true,
    shell => "/opt/couchbase/bin/cbq",
    password => '$1$Ksq1VeaW$l43xXLM6w8bRQKcnk4fEp1', #requires gem ruby-shadow to edit shadowfile
    require => Package["couchbase-server"]
}

# Update the System
exec { "apt-get update":
     path => "/usr/bin"
}

# Install libssl dependency
package { "libssl0.9.8":
    name => $operatingsystem ? {
        Ubuntu => "libssl0.9.8",
        CentOS => "openssl098e",
        Debian => "libssl1.0.0",
    },
    ensure => present,
    before => Package["couchbase-server"]
}

# Install Couchbase Server
package { "couchbase-server":
    provider => $operatingsystem ? {
        Ubuntu => dpkg,
        CentOS => rpm,
        Debian => dpkg,
    },
    ensure => installed,
    source => "/vagrant/prov/$filename",
}

# Ensure the service is running
service { "couchbase-server":
	ensure => "running",
	require => Package["couchbase-server"]
}

# Install a simple lightweight http static server
class nginx{
  package { "nginx":
    ensure => present,
    require => Exec ["apt-get update"],
  }
    service { "nginx":
        ensure  => "running",
        require => Package["nginx"],
    }

    file { "/var/www":
        ensure  => "link",
        target  => "/vagrant/resources/www",
        require => Package["nginx"],
        notify  => Service["nginx"],
        force => true,
    }

    file { 'vagrant-nginx':
	path => '/etc/nginx/sites-available/vagrant',
	ensure => file,
    replace => true,
	require => Package['nginx'],
	source => "/vagrant/resources/nginxvagrant",
    notify => Service['nginx'],
}

file { 'default-nginx-disable':
	path => '/etc/nginx/sites-enabled/default',
	ensure => absent,
	require => Package['nginx'],
}

file { 'vagrant-nginx-enable':
	path => '/etc/nginx/sites-enabled/vagrant',
	target => '/etc/nginx/sites-available/vagrant',
	ensure => link,
	notify => Service['nginx'],
	require => [
		File['vagrant-nginx'],
		File['default-nginx-disable'],
	],
}
}

include nginx
