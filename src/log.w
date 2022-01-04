
@** Release history.

\font\df=cmbx12
\def\date#1{{\medskip\noindent\df #1\medskip}}
\parskip=1ex
\parindent=0pt

\date{Release 1: March 2002}

Initial release.

\date{Release 1.1: February 2003}

Minor source code changes for compatibility with
\.{gcc} 3.2.2.  Compatibility with earlier compiler
versions is maintained.

\date{Release 1.2: October 2003}

Fixes for runaway purity of essence in GCC's library handling
of the humble \.{errno} variable.

\date{Release 1.3: August 2004}

Fixed compatibility problems with libraries on Solaris 5.9. Ported
Win32 build process to Visual Studio .net, which produces a native
Win32 binary which doesn't need to load the DOS extender as \.{DJgpp}
did.

\date{Release 1.4: January 2011}

Fixed warnings from GCC 4.4.5 and Autoconf 2.67.

\date{Release 1.5: August 2019}

Fixed error messages and warnings due to further fanaticism
in GCC 7.4.0.  Fixed PDF generation so it no longer requires
\.{CWEB} to be installed in the system's \TeX\ environment.
Fixed a bug in processing word lists containing ISO-8859
8 bit characters.


@** Development log.

\date{2002 February 23}

Created development tree and commenced implementation.

\date{2002 February 26}

Much \.{autoconf} plumbing today to get things to work on
Solaris without installing GNU \CPP/ dynamic libraries.
I finally ended up having \.{autoconf} sense the operating
system type with \.{uname} and, if it's
``\.{SunOS}'', tack \.{-static} onto the link.  Static
linking on Solaris resulted in an error about doubly
defined exported symbols in \.{getopt.c}, but
commenting out these symbols seems to fix the problem
on Solaris and still work on Linux.  Static linking
on Linux works fine but takes {\it forever}, so it's
worth making the test to speed up the development cycle.

\date{2002 March 2}

Okay, it's basically working now, so it's time to start
optimising this horrifically slow program so it doesn't
kill the server when we announce it to the public.  I
started with a test string which, when compiled with
\.{-g -O2} on Lysander, ran 8.690 seconds.

I compiled with \.{-pg} and ran \.{gprof} and discovered,
to nobody's amazement, that it's spending a huge amount of time
counting letters and classifying characters.  It was high
time to get rid of all that procedural code in the inner loop,
so I defined a |letter_category| table which is initialised once
with pointers to global category counts with names like
|G_lower| and |G_digits|.  You can reset the counts with the
macro |G_clear()|.  The table is filled in with pointers using
procedural code as before.  Once the table is built, the category
counter simply increments the counter pointed to by indexing
the table.  The counts are then copied to the corresponding fields
in the |dictionaryWord| object.  Result: run time fell to 7.030
seconds.

Adding two dictionary words to concatenate them performed a
complete re-count of the string.  I added a |*+| operator which
simply concatenates the two strings and adds the letter and
character category counts.  Using this precisely once, where
|anagram_search| generates its candidate phrases, reduced
run time to 6.510 seconds.

I further sped up candidate testing in |anagram_search| by adding
a special-purpose |contained| method to |dictionaryWord|.  This
takes pointers to two |dictionaryWords| and tests whether
the two, considered logically concatenated, are ``contained''
within the object word.  This allows testing containment
without ever constructing a new |dictionaryWord| or re-counting
letters.  This sped up the test case to 3.180 seconds.

Yaaar!  Knuth was {\it really} right when he said that
`premature optimisation is the root of all evil.''  I was guilty
of that in |anagram_search| where I made a test on the combined
length of the base phrase and candidate word, without realising
thay the |contained| method would reject the candidate in less
time than that expended in checking the length.

\date{2002 March 3}

Oops$\ldots$specifying a seed or other |dictionaryWord| argument
on the command line or via CGI environment variables crashed
since the |letter_category| table hadn't been initialised.  I
moved the initialisation to before the arguments are parsed.

\date{2002 March 5}

I obtained a massive speed-up (down to about 0.17 seconds on
the test which ran 8.69 seconds at the start of the optimisation)
through the expedient of making an initial pass through the
dictionary and preparing an ``auxiliary dictionary'' which
contains only words which can possibly appear in anagrams of
the target phrase.  If a word in the dictionary contains more
of any letter than the target phrase, it is excluded, and we
never have to consider it during the expensive recursive process
of searching for anagrams.  The auxiliary dictionary |auxdict|
is a table of pointers to words in the binary dictionary, so
referencing through these pointers never requires copiying data.

In the same optimisation pass, I modified the anagram search
function which uses the auxiliary dictionary, |a_anagram_search|,
to keep its anagram candidate stack as a |vector<dictionaryWord*>|
rather than |dictionaryWord|.  This avoids copying the object
as words are pushed and popped off the stack.

\date{2002 March 12}

Added logic to \.{configure.in} to test whether the system supports
memory mapping of files (using the presence of the |mmap| function
as a proxy).  If it doesn't the |binaryDictionary| |loadFromFile|
method allocates an in-memory buffer and reads the binary dictionary
into it.  We prefer memory mapping since the |MAP_SHARED| attribute
allows any number of processes to share the dictionary in page space,
which reduces memory requirements and speeds things up enormously in
server applications such as CGI scripts.

Integrated the embedded build of \.{ctangle} and \.{cweave} in
the local \.{cweb} directory from \.{EGGSHELL}.  Now the \.{CWEB}
tools will automatically be re-built on the user's system.

\date{2002 March 13}

To simplify use of the stand-alone program from the command line, I rewrote
command line parsing to permit specifying the target as the first command line
argument as long as no \.{--target} options has previously specified it.  You
may still specify seed words after the target argument regardless of
whether it was supplied by \.{target} or as an unqualified argument.

Switched the \.{-b} option from a synonym for \.{--bail} to a
synonym of \.{--bindict}---typical command line users are more
likely to specify an alternative dictionary than request single-word
bailout.

Added some diagnostic output to binary dictionary creation and loading
when the \.{--verbose} option is specified.

Added a \.{--permute} (or \.{-p}) option which generates permutations
of the target phrase rather than anagrams.  This capability was already
in the CGI step 3 processing, but this makes it available to command
line users as well.

\date{2002 March 16}

Several of the single-letter option abbreviations which take an argument
lacked the requisite ``\.{:}'' after the letter in the argument to
|getopt_long|, resulting in a segmentation fault if any were used.
Fixed.

Added documentation to \.{Makefile.in} and \.{INSTALL} that this a
nerdy user-level application which isn't intended to be installed system-wide.

\date{2002 March 17}

Integrated \.{uncgi} 1.10 as a built-in function with the \.{-DLIBRARY}
option, eliminating the need to install the stand-alone program and the
inefficiency executing it entails.

\date{2002 March 20}

Updated the \.{man} page, \.{anagram.1}, synchronising it with the HTML
and built-in program documentation.  Changed the version number to 1.0
in anticipation of release.

\date{2002 March 21}

Cleaned up building on Win32 with \.{DJgpp}.  The complete program is built
by the batch file \.{makew32.bat}.  I added a new \.{winarch} target
to \.{Makefile.in} to create the \.{winarch.zip} file containing
everything you need to build the Win32 executable.

\date{2002 March 22}

Cleaned up all warnings on a \.{-Wall} build with \.{gcc}.

Removed unnecessary header file includes.

Removed \.{CLEAN\_BUT\_SLOW} code in |dictionaryWord|; we're never
going to go back to it, so why not avoid confusion.

Added high level functional documentation for |anagram_search|
which is, after all, where all the real work gets done.

Version 1.0.

\date{2003 February 15}

Cleaned up in order to compile with \.{gcc} 3.2.2.

Changed four instances where a function returning an iterator
to a string was assigned to a |char *| to assign to a
|string::iterator| instead.

Removed ``\.{.h}'' from three \CPP/ header file includes.

With these changes, it still compiles on 2.96 without any
problems.

Version 1.1.

\date{2003 October 5}

The \.{gcc} thought police have now turned their attention to
the humble |errno| variable, necessitating checks in the
\.{configure.in} file for the presence of the
\.{errno.h} header file and |strerror| function which,
if present, is used instead of the reference to
|sys_errlist[errno]| which has worked perfectly
for decades.  I retested building on \.{gcc} 3.2.2 and
2.96 on Linux and 2.95.3 on Solaris.

Version 1.2.

\date{2004 August 20}

The definition of our local |getopt| causes a compile
time error with recent versions of \.{gcc} on Solaris
5.9 systems, which contain an incompatible definition
in \.{stdlib.h}.  Since we don't use |getopt| at all,
I simply disabled its definition in \.{getopt.h}.  (It
was already disabled in \.{getopt.c}.)  Tested building
with \.{gcc} 3.4.1: everything is fine except for two
warnings in the \.{CWEB} programs which I'll not fix
in order to stay with Knuth and Levy's canonical source
code.  All modules of the program proper are
\.{-Wall} clean on 3.4.1.

\date{2004 August 31}

Ported the Win32 executable build to Visual Studio .net.
This required fixes to \.{getopt.c}, \.{getopt.h}, and \.{uncgi.c} to work
around the eccentricities of that regrettable compiler.
I also added a tweak to the |WIN32| special case in
\.{anagram.w} to undefine |HAVE_UNISTD_H| if it happens to
be set in \.{config.h} to avoid an error due to the
absence of that file in Monkey C's libraries.
Note that the ``Debug'' build of the project actually
compiles with |NDEBUG| and links with the non-debug
library thanks to the ``Library is corrupt'' crap.

If you ran ``\.{make dist}'' without first performing
a ``\.{make clean}'', executables for the \.{cweave} and
\.{ctangle} programs would be included in the \.{cweb}
directory in the distribution.  Fixed.

Version 1.3.

\date{2011 January 25}

Fixed conflicting definitions of \.{string.h} functions in \.{cweb/common.c},
\.{cweb/ctangle.c}, and \.{cweb/cweave.c} which caused natters from
\.{gcc} 4.4.5.

Fixed code in \.{cweb/ctangle.c} and \.{cweb/cweave.c} which passed strings
without format phrases to \.{printf} as a single argument.  Nanny-compiler
\.{gcc} now considers these to be possible security risks.

Added a ``\.{datarootdir = @@datarootdir@@}'' declaration to \.{Makefile.in}
to get rid of a natter from Autoconf 2.67.

Version 1.4.

\date{2019 August 8}

Another turn of the screw from the GCC pointy-heads.  Declaring
a function as ``\.{extern "C" void zot(void)}'' now gets a
Microsoft-style error message, ``expected unqualified-id before
user-defined string literal''. It turns out you now have to say
``\.{extern "C" \{ void zot(void) \}}'' instead.  Purity of
essence, don't you know?

The build of \.{anagram.pdf} would fail if the \.{CWEB} macros
were not installed in the system's TeX directory tree.  I added
a definition to the \.{pdftex} command in \.{Makefile.in} to add
our local \.{cweb} directory to the include search path.

GCC 7.4.0 gives a warning if a string macro is not separated
from an adjacent string literal by one or more spaces.  Again,
this is pure fanaticism, and it runs afoul of how CTANGLE
formats its output code.  I reformatted the code which handles
the \.{--version} option by adding line breaks around the macro
references which tricks CTANGLE into avoiding the warnings.

In keeping with Fourmilab's current source code standards, I
expanded all tabs in \.{anagram.w} and \.{log.w} to spaces and
trimmed any trailing space which had crept in.

The \.{dictionaryWord::countLetters()} method would fail with a
segmentation fault if the source dictionary contained ISO
characters with code points greater than 127.  The code which
extracts characters from the word used a signed \.{char} rather
than an \.{unsigned char}.  My suspicion is that this is a
legacy bug which never manifested itself on the ancient Solaris
compiler on which this was developed because in it \.{char} is
unsigned.

Version 1.5.

%%%%%%%%%    Add new entries before this line    %%%%%%%%%
\parskip=0pt plus1pt
\parindent=20pt
