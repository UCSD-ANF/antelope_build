#!/usr/bin/env python
# vim:ft=python

import os
import sys
import subprocess
import collections
import shutil
import re

###
# Config
###

# Location of the Antelope installers. There should be a directory for
# each version
INSTALLER_BASEDIR=os.path.join(os.sep,'anf','software','antelope','cd')
INSTALLER_CMD_NAME='Install_antelope'

# Location of the initial license.pf and site.pf
INITIAL_PF_DIR=os.path.join(INSTALLER_BASEDIR,'pf')

class AntelopeInstallerException(Exception):
  """Base class for errors in this script"""
  pass

class UnknownAntelopeVersionException(AntelopeInstallerException):
  """Unable to determine what version of Antelope to install"""
  pass

class AntelopeInstallerRuntimeException(AntelopeInstallerException):
  """General runtime error in the Antelope installer"""
  pass

def flatten(l):
  for el in l:
    if isinstance(el, collections.Iterable) \
       and not isinstance(el,basestring):
      for sub in flatten(el):
        yield sub
    else:
      yield el

def get_antelope_base_dir(version=None):
  basedir=os.path.join(os.sep,'opt','antelope')

  if version:
    return os.path.join(basedir,version)

  return basedir

def get_version_from_env(varName='ANTELOPE'):
  envVal=os.environ.get(varName)
  try:
    (dirName, antelopeVersion) = os.path.split(envVal)
    if dirName == get_antelope_base_dir():
      return antelopeVersion
    return ''
  except:
    return ''

def get_version_from_cwd():
  cwd=os.getcwd()
  (parentDir,thisDir) = os.path.split(cwd)
  if thisDir == 'src':
    (junk,antelopeVersion) = os.path.split(parentDir)
    return antelopeVersion
  return ''

def get_requested_version():
  requestedVersion=os.environ.get('REQUESTED_ANTELOPE')
  envVersion=get_version_from_env()

  if requestedVersion != None:
    if requestedVersion != envVersion:
      print >> sys.stderr, \
          'WARNING: requested version of Antelope %s' \
          "and environment %s don't match" % (requestedVersion,
                                              envVersion)
  else:
    requestedVersion = envVersion

  if requestedVersion == None or requestedVersion == '':
    requestedVersion=get_version_from_cwd()

  if requestedVersion == None or requestedVersion == '':
    raise UnknownAntelopeVersionException(
      "Couldn't determine which version of Antelope to install")

  return requestedVersion

def parseAntelopeVersion(version):
    """ Return a tuple of major, minor, suffix related to the antelope version
    """
    m = re.match(r"^(\d+)\.(\d+)(.*)$",version)
    return m.group(1,2,3)

def get_installer_args(version):
    basic_args= [ '-t', '-u', '-v' ]

    (major,minor,suffix)=parseAntelopeVersion(version)

    # The -S option to skip cd image verification was introduced in 5.3pre
    # It MUST come before the -t, -u, and -v options when used for 5.3-5.7
    args = []
    if (int(major) >= 5 and int(minor) >=3):
        args.append('-S')

    # The -m option to skip sudo commands was introduced in 5.8pre and is
    # required for our build hosts
    if (int(major) >= 5 and int(minor) >=8):
        args.append('-m')

    # Finally, add all of the basic arguments
    args.extend(basic_args)

    return args

def check_successful_output(output,version):
    (major,minor,suffix)=parseAntelopeVersion(version)
    if int(major) >= 5 and int(minor) >= 3:
        if output.find('Done') < 0:
            raise AntelopeInstallerRuntimeException(output)
    else:
        if output.find("Thanks for using Antelope!") < 0:
            raise AntelopeInstallerRuntimeException(output)

def run_installer(version):
  print >>sys.stderr, "Installing Antelope %s" % version
  installerCmd = os.path.join(INSTALLER_BASEDIR, version,
                              INSTALLER_CMD_NAME)
  #output=subprocess.check_output(
  #  flatten([installerCmd, INSTALLER_ARGS]),
  #  stderr=subprocess.STDOUT)
  args=get_installer_args(version)
  print >>sys.stderr, "Using installer: %s with args: %s" % (installerCmd, args)
  p = subprocess.Popen(flatten([installerCmd, args]),
       stderr=subprocess.STDOUT, stdout=subprocess.PIPE)
  (output,junk)=p.communicate()

  if p.returncode != 0:
    raise AntelopeInstallerRuntimeException("[RESULT CODE 0]\n" + output)


  errorStrings=("Cannot proceed with verification",
                'Please fix the above problems, then try again.')

  # Look for common error strings
  for err in errorStrings:
    if output.find(err) >= 0:
      raise AntelopeInstallerRuntimeException(output)

  # If the installer bails out early, it won't print 'Done.'
  check_successful_output(output,version)

def copy_license_pf(version):
  print >>sys.stderr, "Installing initial site.pf"
  src=os.path.join(INITIAL_PF_DIR,'site.pf')
  dest=os.path.join(get_antelope_base_dir(version),
                    'data','pf','site.pf')
  shutil.copyfile(src,dest)

def copy_site_pf(version):
  print >>sys.stderr, "Installing initial license file"
  src=os.path.join(INITIAL_PF_DIR,version + '_license.pf')
  dest=os.path.join(get_antelope_base_dir(version),
                    'data','pf','license.pf')
  shutil.copyfile(src,dest)

def copy_baseline_parameter_files(version):
  copy_license_pf(version)
  copy_site_pf(version)

def test_all():
  print "ANTELOPE is %s" % get_version_from_env()
  print "JUNKO is %s" % get_version_from_env("JUNKO")
  print "CWD version is %s" % get_version_from_cwd()

  ver=get_requested_version()
  print "Requested Antelope Version is %s" % ver

### MAIN ###
def main():
    """Main logic for the program"""

    try:
        version=get_requested_version()
        run_installer(version)
        copy_baseline_parameter_files(version)
    except (AntelopeInstallerRuntimeException),e:
        print >> sys.stderr, "ERROR: The Antelope installer failed to " \
                "complete successfully. Output is below.\n", \
                '---------------------------------', \
                e, \
                '\n---------------------------------'
        sys.exit(2)
    except (UnknownAntelopeVersionException),e:
        print >> sys.stderr, \
                "ERROR: Couldn't determine which version of Antelope to install."
        sys.exit(3)
    except (Exception),e:
        print >>sys.stderr, "ERROR: Something went wrong:\n", e
        sys.exit(1)
    sys.exit(0)

if __name__ == "__main__":
    main ()
