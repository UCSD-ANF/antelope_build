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
	@echo "+-+-+ Building AntelopeLocal +-+-+"
	cd $(BUILDROOT)/$(ANTELOPELOCAL_SRCDIR) && $(MAKE) install

antelopelocal_clean: .PHONY
	cd $(BUILDROOT)/$(ANTELOPELOCAL_SRCDIR) && $(MAKE) clean

#############################################################################
# Antelope Local
#############################################################################
CONTRIB_SRCDIR=contrib
contrib: 
	@echo "+-+-+ Building Contrib +-+-+"
	cd $(BUILDROOT)/$(CONTRIB_SRCDIR) && \
	  echo "+++ Running make Include in contrib" && $(MAKE) Include && \
	  echo "+++ Running make install in contrib" && $(MAKE) install

contrib_clean: .PHONY
	cd $(BUILDROOT)/$(CONTRIB_SRCDIR) && $(MAKE) clean

update:
	git pull
	git submodule update

# Dummy target (useful for non-GNU makes
.PHONY:
