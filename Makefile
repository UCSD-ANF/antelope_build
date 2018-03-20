BUILDROOT=build
# The default target is ...
all:
	@echo "WARNING: This target does nothing. Try one of\n\
	* antelope_update\n\
	* antelope_install\n\"
	* antelope_purge_old"

submodules:
	@echo "The submodules target is deprecated and no longer does anything"

CLEAN_TARGETS  = antelope_purge_old

clean: $(CLEAN_TARGETS)
###
# Installation and update
###
antelope_install:
	./libexec/antelope_install_wrapper

antelope_update:
	antelope_update -tvQ

antelope_purge_old:
	rm -rf /opt/antelope/old/*
###
# Update this git repository
###
update:
	git pull
# Dummy target (useful for non-GNU makes)
.PHONY:
