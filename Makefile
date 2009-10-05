GIT=/opt/csw/bin/git

# The default target is ...
#all: antelopelocal rrdtool perlmagick contrib vorb
BUILDROOT=build
all: antelopelocal contrib

clean: antelopelocal_clean contrib_clean

#############################################################################
# Antelope Local
#############################################################################
ANTELOPELOCAL_SRCDIR=antelopelocal
antelopelocal: 
	cd $(BUILDROOT)/$(ANTELOPELOCAL_SRCDIR) && $(MAKE) install

antelopelocal_clean: .PHONY
	cd $(BUILDROOT)/$(ANTELOPELOCAL_SRCDIR) && $(MAKE) clean

#############################################################################
# Antelope Local
#############################################################################
CONTRIB_SRCDIR=contrib
contrib: 
	cd $(BUILDROOT)/$(CONTRIB_SRCDIR) && $(MAKE) Include && $(MAKE) install

antelopelocal_clean: .PHONY
	cd $(BUILDROOT)/$(CONTRIB_SRCDIR) && $(MAKE) clean


# Dummy target (useful for non-GNU makes
.PHONY:
