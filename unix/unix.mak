# $Id: unix.mak,v 35004.50 2007/01/13 23:12:39 kkeys Exp $
########################################################################
#  TinyFugue - programmable mud client
#  Copyright (C) 1994, 1995, 1996, 1997, 1998, 1999, 2002, 2003, 2004, 2005, 2006-2007 Ken Keys
#
#  TinyFugue (aka "tf") is protected under the terms of the GNU
#  General Public License.  See the file "COPYING" for details.
#
#  DO NOT EDIT THIS FILE.
#  To make configuration changes, see "unix/README".
########################################################################

#
# unix section of src/Makefile.
#

SHELL      = /bin/sh
BUILDERS   = Makefile


default: all

install:  _all PREFIXDIRS $(TF) LIBRARY $(MANPAGE) $(SYMLINK)
	@echo
	@echo '#####################################################'
	@echo '## TinyFugue installation successful.'
	@echo '##    tf binary: $(TF)'
	@echo '##    library:   $(TF_LIBDIR)'
#	@echo '##    manpage:   $(MANPAGE)'
	@DIR=`echo $(TF) | sed 's;/[^/]*$$;;'`; \
	echo ":$(PATH):" | egrep ":$${DIR}:" >/dev/null 2>&1 || { \
	    echo "##"; \
	    echo "## Note:  $$DIR is not in your PATH."; \
	    echo "## To run tf, you will need to type its full path name"; \
	    echo "## or add $$DIR to your PATH."; \
	}
	@if test $(TF_LIBDIR) != `cat TF_LIBDIR.build`; then \
	    echo "##"; \
	    echo "## Note:  installed and compiled-in libraries disagree."; \
	    echo "## To run tf, you will need TFLIBDIR=\"$(TF_LIBDIR)\""; \
	    echo "## in your environment or the -L\"$(TF_LIBDIR)\" option."; \
	fi

all files:  _all
	@echo '$(TF_LIBDIR)' > TF_LIBDIR.build
	@echo
	@echo '#####################################################'
	@echo '## TinyFugue build successful.'
	@echo '## Use "$(MAKE) install" to install:'
	@echo '##    tf binary: $(TF)'
	@echo '##    library:   $(TF_LIBDIR)'
#	@echo '##    manpage:   $(MANPAGE)'

_all:  tf$(X) ../lib/tf/tf-help.idx

_failmsg:
#	@echo '#####################################################'
#	@echo '## TinyFugue installation FAILED.'
#	@echo '## See README for help.'
#	@if [ "$(STD_C)" != "1" ]; then \
#	    echo '## '; \
#	    echo '## TF requires a standard (ANSI/ISO 9889-1990) C compiler.'; \
#	    echo '## The standard has existed since 1989, and gcc is freely'; \
#	    echo '## available for many platforms, so there is really no'; \
#	    echo '## excuse for not having a standard compiler at this time.'; \
#	    echo '## If your system does not have one, you should complain'; \
#	    echo '## strongly to the vendor or administrator.  Do not bother'; \
#	    echo '## contacting the author of TF.'; \
#	elif [ "$(CC)" = "gcc" ]; then \
#	    echo '## '; \
#	    echo '## Perhaps $(CC) is not configured correctly.  Before'; \
#	    echo '## contacting the TF author, try setting the environment'; \
#	    echo '## variable CC to "cc", and run ./configure again.'; \
#	fi

TF tf$(X):     $(OBJS) $(BUILDERS)
	$(CC) $(LDFLAGS) -o tf$(X) $(OBJS) $(LIBS)
#	@# Some stupid linkers return ok status even if they fail.
	@test -f "tf$(X)"
#	@# ULTRIX's sh errors here if strip isn't found, despite "true".
	-test -z "$(STRIP)" || $(STRIP) tf$(X) || true

PREFIXDIRS:
	test -d "$(bindir)" || mkdir $(bindir)
	test -d "$(datadir)" || mkdir $(datadir)

install_TF $(TF): tf$(X) $(BUILDERS)
	-@rm -f $(TF)
	cp tf$(X) $(TF)
	chmod $(MODE) $(TF)

SYMLINK $(SYMLINK): $(TF)
	test -z "$(SYMLINK)" || { rm -f $(SYMLINK) && ln -s $(TF) $(SYMLINK); }

LIBRARY $(TF_LIBDIR): ../lib/tf/tf-help ../lib/tf/tf-help.idx
	@echo '## Creating library directory...'
#	@# Overly simplified shell commands, to avoid problems on ultrix
	-@test -n "$(TF_LIBDIR)" || echo "TF_LIBDIR is undefined."
	test -n "$(TF_LIBDIR)"
	test -d "$(TF_LIBDIR)" || mkdir $(TF_LIBDIR)
	-@test -d "$(TF_LIBDIR)" || echo "Can't make $(TF_LIBDIR) directory.  See if"
	-@test -d "$(TF_LIBDIR)" || echo "there is already a file with that name."
	test -d "$(TF_LIBDIR)"
#
#	@#rm -f $(TF_LIBDIR)/*;  # wrong: this would remove local.tf, etc.
	@echo '## Copying library files...'
	cd ../lib/tf; \
	for f in *; do test -f $$f && files="$$files $$f"; done; \
	( cd $(TF_LIBDIR); rm -f $$files tf.help tf.help.index; ); \
	cp $$files $(TF_LIBDIR); \
	cd ../../lib/py; \
	for f in *; do test -f $$f && pyfiles="$$pyfiles $$f"; done; \
	( cd $(TF_LIBDIR); rm -f $$pyfiles tf.help tf.help.index; ); \
	cp $$pyfiles $(TF_LIBDIR); \
	cd $(TF_LIBDIR); \
	chmod $(MODE) $$files; chmod ugo-wx $$files ;\
	chmod $(MODE) $$pyfiles; chmod ugo-wx $$pyfiles
	-rm -f $(TF_LIBDIR)/CHANGES 
	cp ../CHANGES $(TF_LIBDIR)
	chmod $(MODE) $(TF_LIBDIR)/CHANGES; chmod ugo-wx $(TF_LIBDIR)/CHANGES
	chmod $(MODE) $(TF_LIBDIR)
	-@cd $(TF_LIBDIR); old=`ls replace.tf 2>/dev/null`; \
	if [ -n "$$old" ]; then \
	    echo "## WARNING: Obsolete files found in $(TF_LIBDIR): $$old"; \
	fi
	@echo '## Creating links so old library names still work...'
#	@# note: ln -sf isn't portable.
	@cd $(TF_LIBDIR); \
	rm -f bind-bash.tf;    ln -s  kb-bash.tf   bind-bash.tf;    \
	rm -f bind-emacs.tf;   ln -s  kb-emacs.tf  bind-emacs.tf;   \
	rm -f completion.tf;   ln -s  complete.tf  completion.tf;   \
	rm -f factorial.tf;    ln -s  factoral.tf  factorial.tf;    \
	rm -f file-xfer.tf;    ln -s  filexfer.tf  file-xfer.tf;    \
	rm -f local.tf.sample; ln -s  local-eg.tf  local.tf.sample; \
	rm -f pref-shell.tf;   ln -s  psh.tf       pref-shell.tf;   \
	rm -f space_page.tf;   ln -s  spc-page.tf  space_page.tf;   \
	rm -f speedwalk.tf;    ln -s  spedwalk.tf  speedwalk.tf;    \
	rm -f stack_queue.tf;  ln -s  stack-q.tf   stack_queue.tf;  \
	rm -f worldqueue.tf;   ln -s  world-q.tf   worldqueue.tf;

makehelp: makehelp.c
	$(CC) $(CFLAGS) -o makehelp makehelp.c

__always__:

../lib/tf/tf-help: __always__
	if test -d ../help; then cd ../help; $(MAKE) tf-help; fi
	if test -d ../help; then cp ../help/tf-help ../lib/tf; fi

../lib/tf/tf-help.idx: ../lib/tf/tf-help makehelp
	$(MAKE) -f ../unix/unix.mak CC='$(CC)' CFLAGS='$(CFLAGS)' makehelp
	./makehelp < ../lib/tf/tf-help > ../lib/tf/tf-help.idx

MANPAGE $(MANPAGE): $(BUILDERS) tf.1.$(MANTYPE)man
	cp tf.1.$(MANTYPE)man $(MANPAGE)
	chmod $(MODE) $(MANPAGE)
	chmod ugo-x $(MANPAGE)

Makefile: ../unix/vars.mak ../unix/unix.mak ../configure ../configure.ac
	@echo
	@echo "## WARNING: configuration should be rerun."
	@echo

uninstall:
	@echo "Remove $(TF_LIBDIR) $(TF) $(MANPAGE)"
	@echo "Is this okay? (y/n)"
	@read response; test "$$response" = "y"
	rm -f $(TF) $(MANPAGE)
	rm -rf $(TF_LIBDIR)

clean distclean cleanest:
	cd ..; make -f unix/Makefile $@


# development stuff, not necessarily portable.

tags: *.[ch]
	ctags --excmd=pattern port.h tf.h *.[ch] 2>/dev/null

dep: *.c
	gcc -E -MM *.c \
		| sed 's;pcre[^ ]*/pcre.h ;;' \
		| sed '/[^\\]$$/s/$$/ $$(BUILDERS)/' \
		> dep

tf.pixie: tf$(X)
	pixie -o tf.pixie tf$(X)

lint:
	lint -woff 128 $(CFLAGS) -DHAVE_PROTOTYPES $(SOURCE) $(LIBRARIES)

# The next line is a hack to get around a bug in BSD/386 make.
make:
