GIT=/opt/csw/bin/git

# The default target is ...
#all: antelopelocal rrdtool perlmagick contrib vorb
BUILDROOT=build
all: antelopelocal contrib vorb

clean: antelopelocal_clean contrib_clean

#############################################################################
# Antelope Local
#############################################################################
ANTELOPELOCAL_SRCDIR=antelopelocal
antelopelocal: 
	@echo "+-+-+ Building AntelopeLocal +-+-+"
	cd $(BUILDROOT)/$(ANTELOPELOCAL_SRCDIR) && $(MAKE) install

antelopelocal_update: .PHONY
	cd $(BUILDROOT)/$(ANTELOPELOCAL_SRCDIR) && \
	  git checkout master && \
	  git pull
	git commit $(BUILDROOT)/$(ANTELOPELOCAL_SRCDIR) -m "Sync AntelopeLocal to HEAD via Makefile"

antelopelocal_clean: .PHONY
	cd $(BUILDROOT)/$(ANTELOPELOCAL_SRCDIR) && $(MAKE) clean

#############################################################################
# Contrib
#############################################################################
CONTRIB_SRCDIR=contrib
contrib: 
	@echo "+-+-+ Building Contrib +-+-+"
	cd $(BUILDROOT)/$(CONTRIB_SRCDIR) && \
	  echo "+++ Running make Include in $(CONTRIB_SRCDIR)" && $(MAKE) Include && \
	  echo "+++ Running make install in $(CONTRIB_SRCDIR)" && $(MAKE) install

contrib_update: .PHONY
	cd $(BUILDROOT)/$(CONTRIB_SRCDIR) && \
	  git checkout master && \
	  git pull
	git commit $(BUILDROOT)/$(CONTRIB_SRCDIR) -m "Sync contrib to HEAD via Makefile"

contrib_clean: .PHONY
	cd $(BUILDROOT)/$(CONTRIB_SRCDIR) && $(MAKE) clean

#############################################################################
# Vorb
#############################################################################
VORB_SRCDIR=vorb
vorb:
	@echo "+-+-+ Building Vorb +-+-+"
	cd $(BUILDROOT)/$(VORB_SRCDIR) && \
	  echo "+++ Running make Include in $(VORB_SRCDIR)" && $(MAKE) Include && \
	  echo "+++ Running make install in $(VORB_SRCDIR)" && $(MAKE) install

vorb_update: .PHONY
	cd $(BUILDROOT)/$(VORB_SRCDIR) && \
	  git checkout master && \
	  git pull
	git commit $(BUILDROOT)/$(VORB_SRCDIR) -m "Sync Vorb to HEAD via Makefile"

vorb_clean: .PHONY
	cd $(BUILDROOT)/$(VORB_SRCDIR) && $(MAKE) clean

#############################################################################
# ANF
#############################################################################
ANF_SRCDIR=anfsrc
anf:
	@echo "+-+-+ Building ANF SRC +-+-+"
	cd $(BUILDROOT)/$(ANF_SRCDIR) && \
	  echo "+++ Running make Include in $(ANF_SRCDIR)" && $(MAKE) Include && \
	  echo "+++ Running make install in $(ANF_SRCDIR)" && $(MAKE) install

anf_update: .PHONY
	cd $(BUILDROOT)/$(ANF_SRCDIR) && \
	  git checkout master && \
	  git pull
	git commit $(BUILDROOT)/$(ANF_SRCDIR) -m "Sync ANFSRC to HEAD via Makefile"

anf_clean: .PHONY
	cd $(BUILDROOT)/$(ANF_SRCDIR) && $(MAKE) clean

#############################################################################
# Update this git repository
#############################################################################
update:
	git pull
	git submodule init
	git submodule update

# Dummy target (useful for non-GNU makes
.PHONY:
