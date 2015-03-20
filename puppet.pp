# ===
# Install and Run Couchbase Server
# ===

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

# Download N1QL DP4 and extract
exec { "couchbase-n1ql-dp4":
    command => "/usr/bin/wget $n1qlurl && tar -zxf $n1qlarchive",
    cwd => "/vagrant/prov",
    creates => "/vagrant/prov/cbq-dp4",
    before => File['cbq-alias'],
    timeout => 1200
}


file { "cbq-alias":
    path => "/home/vagrant/.bash_aliases",
    owner => "vagrant",
    ensure => "present",
    content => "alias cbq='/vagrant/prov/cbq-dp4/cbq -engine=http://localhost:8093/'",
    before => Service['couchbase-server']
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
