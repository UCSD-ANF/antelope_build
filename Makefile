GIT=/opt/csw/bin/git

# The default target is ...
#all: antelopelocal rrdtool perlmagick contrib vorb
BUILDROOT=build
all: antelopelocal

clean: antelopelocal_clean

#############################################################################
# Antelope Local
#############################################################################
ANTELOPELOCAL_SRCDIR=antelopelocal
antelopelocal: 
	cd $(BUILDROOT)/$(ANTELOPELOCAL_SRCDIR) && $(MAKE) install

antelopelocal_clean: .PHONY
	cd $(BUILDROOT)/$(ANTELOPELOCAL_SRCDIR) && $(MAKE) clean

##############################################################################
# rrdtool
#
# This only builds RRDs.pm in the current configuration. Requires CSWrrdtool
# to be installed
##############################################################################


# Dummy target (useful for non-GNU makes
.PHONY:
