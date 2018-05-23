#!/usr/bin/perl -w

# Wrapper script to install Antelope Mapdata

use strict;
use warnings;
use version;

my $requested_antelope;
if ( defined $ENV{'REQUESTED_ANTELOPE'} ) {
  $requested_antelope = $ENV{'REQUESTED_ANTELOPE'};
} else {
  print "\nERROR: REQUESTED_ANTELOPE env var must be set\n\n";
  exit -1;
}

my $os_family = $^O;
my $os_major_version;
my $antelope_base = '/opt/antelope';
my $antelope_path = "$antelope_base/$requested_antelope";
my $antelope_setup = "$antelope_path/setup.sh";
my $antelope_map_install_cmd = "$antelope_path/bin/install_mapdata";

# If we're on Linux, make sure we're on CentOS7(or higher), 
# otherwise exit without error
$os_major_version = `facter operatingsystemmajrelease`;
if ( $os_family eq 'linux' && $os_major_version < 7 ) {
  print "Only CentOS7 is supported at this time\n";
  exit 0;
}

# Install mapdata
print "Installing Antelope Mapdata...\n";
print "$antelope_map_install_cmd...\n";
system ( "source $antelope_setup &&" . "$antelope_map_install_cmd" );
if ( $? != 0 ) {
  print "$0 Mapdata install failed.\n";
  exit -1;
}
exit 0;
