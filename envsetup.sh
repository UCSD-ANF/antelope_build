# environment setup file for building Antelope

# determine the version of antelope that we are building for
DEFAULT_ANTVER=5.0-64
currentdir=`pwd`
if [ `basename $currentdir` == 'src' ]; then
  parentdir=`dirname $currentdir`
  antver=`basename $parentdir`
  echo "Antelope version is $antver" 1>&2
else
  echo "Unable to determine which version of Antelope you want based on the current directory name. Using default of $DEFAULT_ANTVER"
  antver=$DEFAULT_ANTVER
fi

# Set up the umask to allow others to tweak the tree
umask 0002

# Make sure that CVS is using SSH
CVS_RSH=ssh
export CVS_RSH

# Override the PATH and build tools
case `uname -s` in
  Darwin)
  ;;
  SunOS)

  PATH=/usr/ccs/bin:/usr/bin:/usr/sbin:/bin:/usr/sfw/bin:/opt/SUNWspro/bin:/opt/csw/bin:/usr/local/bin
  ## NOTE -- /opt/matlab/bin must be in your path otherwise the Antelope MATLAB wxtenstions won't get built.
  export PATH

  TAR=/opt/csw/bin/gtar
  CC=/opt/SUNWspro/bin/cc
  F77=/opt/SUNWspro/bin/f77
  CXX=/opt/SUNWspro/bin/CC
  CCC=${CXX}
  export TAR CC F77 CXX
  ;;
  *)
  echo "WARNING: unknown OS Type `uname -s`" 1>&2
esac

if [ -d /opt/anf/${antver}/ ]; then
  . /opt/anf/${antver}/setup.sh
else
  . /opt/antelope/${antver}/setup.sh
cat 1>&2 << EOF
WARNING: /opt/anf/${antver} does not exist. Setting up only basic Antelope environment. Please bootstrap the Anf tree by running:

make update
( cd build/anfsrc/coldstart && make )

Then, re-source this script to make sure that the \$ANF environment is set up correctly
EOF
fi

unset antver
