# The default target is ...
BUILDROOT=build
all: antelopelocal anf contrib vorb

clean: antelopelocal_clean anf_clean contrib_clean vorb_clean

###
# Installation and update
###
antelope_install:
	./libexec/antelope_install_wrapper

antelope_update:
	antelope_update -tv
###
# Antelope Local
###
ANTELOPELOCAL_SRCDIR=antelopelocal
antelopelocal:
	@echo "+-+-+ Building AntelopeLocal +-+-+"
	cd $(BUILDROOT)/$(ANTELOPELOCAL_SRCDIR) && $(MAKE) install

antelopelocal_update: .PHONY
	cd $(BUILDROOT)/$(ANTELOPELOCAL_SRCDIR) && \
	  git checkout master && \
	  git pull
	-git commit $(BUILDROOT)/$(ANTELOPELOCAL_SRCDIR) \
	  -m "Sync AntelopeLocal to HEAD via Makefile"

antelopelocal_clean: .PHONY
	cd $(BUILDROOT)/$(ANTELOPELOCAL_SRCDIR) && $(MAKE) clean

###
# Contrib
###
CONTRIB_SRCDIR=contrib
contrib:
	@echo "+-+-+ Building Contrib +-+-+"
	cd $(BUILDROOT)/$(CONTRIB_SRCDIR) && \
	  echo "+++ Running make Include in $(CONTRIB_SRCDIR)" && \
	  $(MAKE) Include && \
	  echo "+++ Running make install in $(CONTRIB_SRCDIR)" && \
	  $(MAKE) install

contrib_update: .PHONY
	cd $(BUILDROOT)/$(CONTRIB_SRCDIR) && \
	  git checkout master && \
	  git pull
	-git commit $(BUILDROOT)/$(CONTRIB_SRCDIR) \
	  -m "Sync contrib to HEAD via Makefile"

contrib_clean: .PHONY
	cd $(BUILDROOT)/$(CONTRIB_SRCDIR) && $(MAKE) clean

###
# Vorb
###
VORB_SRCDIR=vorb
vorb:
	@echo "+-+-+ Building Vorb +-+-+"
	cd $(BUILDROOT)/$(VORB_SRCDIR) && \
	  echo "+++ Running make Include in $(VORB_SRCDIR)" && \
	  $(MAKE) Include && \
	  echo "+++ Running make install in $(VORB_SRCDIR)" && \
	  $(MAKE) install

vorb_update: .PHONY
	cd $(BUILDROOT)/$(VORB_SRCDIR) && \
	  git checkout master && \
	  git pull
	-git commit $(BUILDROOT)/$(VORB_SRCDIR) \
	  -m "Sync Vorb to HEAD via Makefile"

vorb_clean: .PHONY
	cd $(BUILDROOT)/$(VORB_SRCDIR) && $(MAKE) clean

###
# ANF
###
ANF_SRCDIR=anfsrc
anf:
	@echo "+-+-+ Building ANF SRC +-+-+"
	cd $(BUILDROOT)/$(ANF_SRCDIR) && \
	  echo "+++ Running make Include in $(ANF_SRCDIR)" && \
	  $(MAKE) Include && \
	  echo "+++ Running make install in $(ANF_SRCDIR)" && \
	  $(MAKE) install

anf_update: .PHONY
	cd $(BUILDROOT)/$(ANF_SRCDIR) && \
	  git checkout master && \
	  git pull
	-git commit $(BUILDROOT)/$(ANF_SRCDIR) \
	  -m "Sync ANFSRC to HEAD via Makefile"

anf_clean: .PHONY
	cd $(BUILDROOT)/$(ANF_SRCDIR) && $(MAKE) clean

###
# Update this git repository
###
update:
	git pull
	git submodule sync
	git submodule init
	git submodule update

###
# Submodule Updates
###

SUBMODULE_UPDATE_TARGETS  = antelopelocal_update
SUBMODULE_UPDATE_TARGETS += contrib_update
SUBMODULE_UPDATE_TARGETS += vorb_update
SUBMODULE_UPDATE_TARGETS += anf_update
submodule_update: $(SUBMODULE_UPDATE_TARGETS)

# list of dirs to fix permissions on
ANTDIRS  = 4.11 4.11p
ANTDIRS += 5.0-64 5.0-64p
ANTDIRS += 5.1-64 data local
ANTDIRS += perl5.10 perl5.10-64 perl5.8
ANTDIRS += tcltk8.4.16-64 tcltk8.4.4

fixperms: .PHONY
	cd /opt/antelope && \
	  sudo chown -PR rt:antelope $(ANTDIRS) ; \
	  sudo chmod -PR ug+rw $(ANTDIRS)

# Dummy target (useful for non-GNU makes)
.PHONY:
