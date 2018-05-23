#!/usr/bin/perl -w

# Wrapper script to install the Antelope toolchain

use strict;
use warnings;
use version;

# Usage
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
my $antelope_tc;
my $antelope_tc_dir;
my $antelope_tc_install_cmd = "$antelope_path/bin/install_toolchain -d $antelope_base";
my $version = "v$requested_antelope";

# Strip out 'pre' if exists
$version =~ tr/pre//d;

# Determine which toolchain we need to install
if ( $os_family eq 'darwin' ) {
  # Only install on Darwin if Antelope version is >= 5.8
  if ( version->parse($version) >= version->parse('v5.8') ) {
    $antelope_tc = 'osx1095_clang500';
    $antelope_tc_dir = "$antelope_base/toolchains/osx1095/clang-5.0.0";
  } else {
    print "\nAborting install, antelope version $requested_antelope < 5.8\n";
    exit 0;
  }
} else {
  # Only install on CentOS 7 and Antelope >= 5.7
  $os_major_version = `facter operatingsystemmajrelease`;
  if ( $os_family eq 'linux' && $os_major_version >= 7 &&
       version->parse($version) >= version->parse('v5.7') ) {
    # For antelope v5.7 set toolchain to centos6_gcc530
    if ( version->parse($version) == version->parse('v5.7') ) {
      $antelope_tc = 'centos6_gcc530';
      $antelope_tc_dir = "$antelope_base/toolchains/centos6/gcc-5.3.0";
    }
    # For antelope v5.8 and higher, use centos74_gcc720
    if ( version->parse($version) >= version->parse('v5.8') ) {
      $antelope_tc = 'centos74_gcc720';
      $antelope_tc_dir = "$antelope_base/toolchains/centos74/gcc-7.2.0";
    }
  } else {
    print "OS $os_family $os_major_version \nAntelope $version not supported\n";
    exit 0;
  }
}

# Install toolchain if none exists
if ( -d $antelope_tc_dir ) {
  print "\nToolchain $antelope_tc_dir already installed, exiting...\n";
  exit 0;
} else {
  print "\nExecuting $antelope_tc_install_cmd $antelope_tc...\n";
  system ( "source $antelope_setup &&"
       . "$antelope_tc_install_cmd $antelope_tc" );
  if ( $? != 0 ) {
    print "$0 Toolchains install failed.\n";
    exit -1;
  }
}

exit 0;
