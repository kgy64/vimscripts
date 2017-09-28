#
#

all: build_vimproc
	@echo
	@echo "---------------------------------------------------------------------------"
	@echo "Build finished. Enter 'make install' to install vim scripts and executables"
	@echo "into your home directory."
	@echo "Note: The old vimrc and other files will be overwritten!"
	@echo "---------------------------------------------------------------------------"
	@echo

install: all copy_files

-include dot-vim/Makefile

clean: dot-vim/Makefile
	$(MAKE) -C dot-vim cleanall
	rm -f $<

copy_files: dot-vim/Makefile
	$(MAKE) -C dot-vim copy

SOURCE_FILES = $(shell find dot-vim bin modules/vimproc/autoload modules/vimproc/doc modules/vimproc/lib modules/vimproc/plugin -type f -a ! -name Makefile -a ! -name ".*" 2>/dev/null)

dot-vim/Makefile: $(SOURCE_FILES)
	@./scripts/create-make $(SOURCE_FILES) >$@

build_vimproc: update
	$(MAKE) -C modules/vimproc

update:
	git submodule update --init

.PHONY: all install update copy_files build_vimproc

