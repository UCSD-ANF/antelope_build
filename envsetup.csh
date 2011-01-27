# environment setup file for building Antelope with C shells
# See also envsetup.sh for Bourne shell variants

# To use this file under a C-compatible shell, type:
# source envsetup.csh

#
# Determine the version of Antelope used to build software
#
# Assume a default of 5.0-64 if we aren't in /opt/antelope/VERSION/src
echo HERE0
set DEFAULT_ANTVER="5.0-64"
set currentdir=`pwd`
echo currentdir is $currentdir
if ( "$currentdir" == 'src' ); then
  set parentdir=`dirname $currentdir`
  set antver=`basename $parentdir`
  sh -c `echo "Antelope version is $antver" 1>&2`
else
  echo "Unable to determine which version of Antelope you want based on the"
  echo "current directory anme. Using default of $DEFAULT_ANTVER"
  set antever = $DEFAULT_ANTVER
endif
unset parentdir

echo HERE1
# Set up the umask to allow others to tweak the tree
umask 0002

# Make sure that CVS is using SSH
setenv CVS_RSH ssh

# Override the PATH and build tools
switch (`uname -s`)
  case Darwin:
    breaksw

  case SunOS:
    set path=( /usr/ccs/bin /usr/bin /usr/sbin /bin /usr/sfw/bin /opt/SUNWspro/bin /opt/csw/bin /usr/local/bin )
    setenv path

    set TAR=/opt/csw/bin/gtar
    set CC=/opt/SUNWspro/bin/cc
    set F77=/opt/SUNWspro/bin/f77
    set CXX=/opt/SUNWspro/bin/CC
    set CCC=$CXX
    setenv TAR
    setenv CC
    setenv F77
    setenv CXX
    breaksw

  default:
    echo "WARNING: unknow OS Type `uname -s`"
endsw

if ( -d /opt/anf/$antver ) then
  source /opt/anf/$antver/setup.csh
else
  source /opt/antelope/$antver/setup.csh
  echo "WARNING: /opt/anf/$antver does not exist. Setting up only basic Antelope environment."
  echo "Please bootstrap the ANF tree by running (inside this repository):"
  echo " "
  echo "make update; (cd build/anfsrc/adm/coldstart && make )"
  echo " "
  echo "Then, re-source this script to make sure that the ANF environment is set up correctly."
endif

