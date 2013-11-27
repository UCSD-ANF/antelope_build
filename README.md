antelope_build
--------------

A repository to control the build and installation of the ANF distribution of
Antelope.


ANF STAFF:
DO NOT DO AN UPDATE OF ANTELOPE WITHOUT OPENING A JIRA ISSUE IN THE ANTELOPE
QUEUE TO TRACK IT

Usage
------

Make sure to set up your environment first:

    . envsetup.sh

Note that if you are not in a directory named src, the script will use a
default version of Antelope which may not be the one you want. Either manually
source the correct Antelope version setup.sh script or check this repository
out to a directory named _requested_antelope_ver_/src where
_requested_antelope_ver_ is something like "5.3" or "5.2-64"

For example it can be checked out to /opt/antelope/5.3/src or
/export/antelope_build/5.3/src and the automatic version detection logic will
work.

Useful Targets in this Makefile
-------------------------------

submodule_update - updates the anfsrc, contrib, and vorb repos from upstream

update - updates this repository from upstream

fixperms - fix permissions on the /opt/antelope tree for selected directories
