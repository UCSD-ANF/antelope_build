GIT=/opt/csw/bin/git

# The default target is ...
#all: antelopelocal amakelocal rrdtool perlmagick contrib vorb
BUILDROOT=build
all: antelopelocal amakelocal

clean: antelopelocal_clean

#############################################################################
# Antelope Local
#############################################################################
ANTELOPELOCAL_SRCDIR=antelopelocal.git
antelopelocal: antelopelocal_gitpull
	cd $(BUILDROOT)/$(ANTELOPELOCAL_SRCDIR) && $(MAKE) install

antelopelocal_gitpull: .PHONY
	cd $(BUILDROOT)/$(ANTELOPELOCAL_SRCDIR) && $(GIT) pull

antelopelocal_clean: .PHONY
	cd $(BUILDROOT)/$(ANTELOPELOCAL_SRCDIR) && $(MAKE) clean

##############################################################################
# amakelocal.pf
##############################################################################
AMAKELOCAL_DESTDIR=$(ANTELOPE)/data/pf

amakelocal: $(AMAKELOCAL_DESTDIR)/amakelocal.pf

$(AMAKELOCAL_DESTDIR)/amakelocal.pf: files/amakelocal.pf
	install amakelocal.pf $(AMAKELOCAL_DESTDIR)

##############################################################################
# rrdtool
#
# This only builds RRDs.pm in the current configuration. Requires CSWrrdtool
# to be installed
##############################################################################


# Dummy target (useful for non-GNU makes
.PHONY:
