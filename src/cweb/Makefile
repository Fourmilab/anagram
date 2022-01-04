# Generated automatically from Makefile.in by configure.
# $Id: Makefile.in,v 1.31 1999/10/14 23:47:53 mason Exp $

# autoconf/Make.common.in        -*- Makefile -*-
# release date (man), LSM date, version number/name, current maintainer
DATE="7 January 2002"
LSMDATE=07Jan02
VERSION=1.10
VERNAME=bacula-$(VERSION)#
MAINT=Kern Sibbald#
MAINTEMAIL=<kern@sibbald.com>#
WEBMAINT=#
WEBMAINTEMAIL=#
WEBPAGE=#
FTPSITENAME=#
FTPSITEDIR=#
#-------------------------------------------------------------------------

SHELL = /bin/sh

# This variable makes it possible to move the installation root to another
# directory. This is useful when you're creating a binary distribution
# If empty, normal root will be used.
# You can run eg. 'make install DESTDIR=/packages/rxvt-xx' to accomplish
# that.
# DESTDIR = /usr/local/X11/$(VERNAME)

# Installation target directories & other installation stuff
prefix = /usr/local
exec_prefix = ${prefix}
binprefix =
manprefix =
sbindir = /home/kelvin/bacula/bin
sysconfdir = /home/kelvin/bacula/bin
mandir = ${prefix}/man/man1
manext = 1

# Tools & program stuff
CC = gcc
CPP = gcc -E
CXX = c++
MV = /bin/mv
RM = /bin/rm
RMF = /bin/rm -f
CP = /bin/cp
SED = /bin/sed
AWK = /bin/awk
ECHO = /bin/echo
CMP = /usr/bin/cmp
TBL = /usr/bin/tbl
AR = /usr/bin/ar
RANLIB = /usr/bin/ranlib
INSTALL = /usr/bin/install -c
# add the -s to the following in PRODUCTION mode
INSTALL_PROGRAM = /usr/bin/install -c -m 755
INSTALL_DATA = /usr/bin/install -c -m 644
INSTALL_SCRIPT = /usr/bin/install -c -m 755

# Flags & libs
CFLAGS = -g -Wall 
CPPFLAGS = 
LDFLAGS =  -L/home/kelvin/mysql/lib/mysql -lmysqlclient
#DEFS = -DHAVE_CONFIG_H
LIBS = -lpthread 
DINCLUDE = 
DLIB = 

# X Include directory
#XINC =  -I/usr/X11R6/include @XPM_CFLAGS@

# extra libraries needed by X on some systems, X library location
#XLIB =  -L/usr/X11R6/lib @XPM_LIBS@ -lX11 

# End of common section of the Makefile
#-------------------------------------------------------------------------

srcdir =	.
.PATH:		.

# one up
basedir = ..
# top dir
topdir = ../..
# this dir relative to top dir
thisdir = src/cweb


DEBUG=

first_rule: all
dummy:

CWEAVE = ./cweave
CTANGLE = ./ctangle

CWEBSRCS = common.c ctangle.c cweave.c

LIBOBJS = common.o ctangle.o cweave.o

EXTRAOBJS = 


.SUFFIXES:	.c .o .dvi .tex .w .pdf
.PHONY:
.DONTCARE:

# inference rules
.c.o:
	$(CC) $(DEFS) $(DEBUG) -c $(CPPFLAGS) -I$(srcdir) -I$(basedir) $(DINCLUDE) $(CFLAGS) $<

.w.tex:
	$(CWEAVE) $*

.tex.dvi:	
	tex $<

.w.dvi:
	make $*.tex
	make $*.dvi

.w.c:
	$(CTANGLE) $*

.w.o:
	make $*.c
	make $*.o

.w.pdf:
	make $*.tex
	case "$(PDFTEX)" in \
	 dvipdfm ) tex "\let\pdf+ \input $*"; dvipdfm $* ;; \
	 pdftex ) pdftex $* ;; \
	esac

#-------------------------------------------------------------------------
all: Makefile cweave ctangle
	@echo "==== Make of cweb is good ===="
	@echo " "


Makefile: $(srcdir)/Makefile.in $(topdir)/config.status
	cd $(topdir) \
	  && CONFIG_FILES=$(thisdir)/$@ CONFIG_HEADERS= $(SHELL) ./config.status

ctangle: ctangle.o common.o
	$(CC) $(LDFLAGS) -L. -o $@ ctangle.o common.o 

cweave: cweave.o common.o
	$(CC) $(LDFLAGS) -L. -o $@ cweave.o common.o 
	
common.c: common.w common_bacula.ch
	$(CTANGLE) common.w common_bacula.ch

ctangle.c: ctangle.w ctangle_bacula.ch
	$(CTANGLE) ctangle.w ctangle_bacula.ch

cweave.c: cweave.w cweave_bacula.ch
	$(CTANGLE) cweave.w cweave_bacula.ch
	 
install:

uninstall:

clean:
	$(RMF) *.a core a.out *.o *.bak *~ *.intpro *.extpro 1 2 3
	$(RMF) cweave ctangle

realclean: clean
	$(RMF) tags

distclean: realclean
	if test $(srcdir) = .; then $(MAKE) realclean; fi
	(cd $(srcdir); $(RMF) Makefile)

# Semi-automatic generation of dependencies:
# Use gcc -MM because X11 `makedepend' doesn't work on all systems
# and it also includes system headers.
# `semi'-automatic since dependencies are generated at distribution time.

depend:
	@$(MV) Makefile Makefile.bak
	@$(SED) "/^# DO NOT DELETE:/,$$ d" Makefile.bak > Makefile
	@$(ECHO) "# DO NOT DELETE: nice dependency list follows" >> Makefile
	@$(CC) -S -M $(CPPFLAGS) $(XINC) -I$(srcdir) -I$(basedir) $(SQL_INC) *.c >> Makefile
	@if test -f Makefile ; then \
	    $(RMF) Makefile.bak; \
	else \
	   $(MV) Makefile.bak Makefile; \
	   echo -e "Something went wrong\n\a"; \
	fi

# -----------------------------------------------------------------------
# DO NOT DELETE: nice dependency list follows
common.o: common.c /usr/include/ctype.h /usr/include/features.h \
  /usr/include/sys/cdefs.h /usr/include/gnu/stubs.h \
  /usr/include/bits/types.h \
  /usr/lib/gcc-lib/i386-redhat-linux/2.96/include/stddef.h \
  /usr/include/bits/pthreadtypes.h /usr/include/bits/sched.h \
  /usr/include/endian.h /usr/include/bits/endian.h /usr/include/stdio.h \
  /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h \
  /usr/include/bits/wchar.h /usr/include/gconv.h \
  /usr/lib/gcc-lib/i386-redhat-linux/2.96/include/stdarg.h \
  /usr/include/bits/stdio_lim.h /usr/include/stdlib.h \
  /usr/include/sys/types.h /usr/include/time.h /usr/include/sys/select.h \
  /usr/include/bits/select.h /usr/include/bits/sigset.h \
  /usr/include/bits/time.h /usr/include/sys/sysmacros.h \
  /usr/include/alloca.h
ctangle.o: ctangle.c /usr/include/stdio.h /usr/include/features.h \
  /usr/include/sys/cdefs.h /usr/include/gnu/stubs.h \
  /usr/lib/gcc-lib/i386-redhat-linux/2.96/include/stddef.h \
  /usr/include/bits/types.h /usr/include/bits/pthreadtypes.h \
  /usr/include/bits/sched.h /usr/include/libio.h /usr/include/_G_config.h \
  /usr/include/wchar.h /usr/include/bits/wchar.h /usr/include/gconv.h \
  /usr/lib/gcc-lib/i386-redhat-linux/2.96/include/stdarg.h \
  /usr/include/bits/stdio_lim.h /usr/include/ctype.h \
  /usr/include/endian.h /usr/include/bits/endian.h /usr/include/stdlib.h \
  /usr/include/sys/types.h /usr/include/time.h /usr/include/sys/select.h \
  /usr/include/bits/select.h /usr/include/bits/sigset.h \
  /usr/include/bits/time.h /usr/include/sys/sysmacros.h \
  /usr/include/alloca.h
cweave.o: cweave.c /usr/include/stdio.h /usr/include/features.h \
  /usr/include/sys/cdefs.h /usr/include/gnu/stubs.h \
  /usr/lib/gcc-lib/i386-redhat-linux/2.96/include/stddef.h \
  /usr/include/bits/types.h /usr/include/bits/pthreadtypes.h \
  /usr/include/bits/sched.h /usr/include/libio.h /usr/include/_G_config.h \
  /usr/include/wchar.h /usr/include/bits/wchar.h /usr/include/gconv.h \
  /usr/lib/gcc-lib/i386-redhat-linux/2.96/include/stdarg.h \
  /usr/include/bits/stdio_lim.h /usr/include/ctype.h \
  /usr/include/endian.h /usr/include/bits/endian.h /usr/include/stdlib.h \
  /usr/include/sys/types.h /usr/include/time.h /usr/include/sys/select.h \
  /usr/include/bits/select.h /usr/include/bits/sigset.h \
  /usr/include/bits/time.h /usr/include/sys/sysmacros.h \
  /usr/include/alloca.h
