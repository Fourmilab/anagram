%
%                           A N A G R A M
%
%                           by John Walker
%                      http://www.fourmilab.ch/
%
%   What's all this, you ask?  Well, this is a "literate program",
%   written in the CWEB language created by Donald E. Knuth and
%   Silvio Levy.  This file includes both the C source code for
%   the program and internal documentation in TeX   Processing
%   this file with the CTANGLE utility produces the C source file,
%   while the CWEAVE program emits documentation in TeX.  The
%   current version of these programs may be downloaded from:
%
%       http://www-cs-faculty.stanford.edu/~knuth/cweb.html
%
%   where you will find additional information on literate
%   programming and examples of other programs written in this
%   manner.
%
%   If you don't want to wade through all these details, don't
%   worry; this distribution includes a .c file already
%   extracted and ready to compile.  If "make" complains that it
%   can't find "ctangle" or "cweave", just "touch *.c"
%   and re-make--apparently the process of extracting the files
%   from the archive messed up the date and time, misleading
%   make into believing it needed to rebuild those files.

%   How to talk about LaTeX without actually ever using it
\def\LaTeX{L\kern-.36em\raise.40ex\hbox{\sevenrm A}\kern-.15em\TeX}

% This verbatim mode assumes that ! marks are !! in the text being copied.
% Borrowed from the CWEB manual: cwebman.tex
\def\verbatim{\begingroup
  \def\do##1{\catcode`##1=12 } \dospecials
  \parskip 0pt \parindent 0pt \let\!=!
  \catcode`\ =13 \catcode`\^^M=13
  \tt \catcode`\!=0 \verbatimdefs \verbatimgobble}
{\catcode`\^^M=13{\catcode`\ =13\gdef\verbatimdefs{\def^^M{\ \par}\let =\ }} %
  \gdef\verbatimgobble#1^^M{}}

\def\CPP/{{\mc C++}}    % Macro for C++, like \CEE/ and \UNIX/
\def\breakOK{\penalty 0}

\def\vbar{\char124}     % Macros for characters difficult to quote in certain contexts
\def\bslash{\char92}
\def\atsign{\char64}
\def\caret{\char94}
\def\uline{\char95}
\def\realspace{\char32}
\def\tilde{\char126}

@i cweb/c++lib.w

@** Introduction.

\vskip 15pt
\centerline{\ttitlefont ANAGRAM}
\vskip 10pt
\centerline{\titlefont Anagram Finder}
\vskip 15pt
\centerline{\pdfURL{by John Walker}{http://www.fourmilab.ch/}}

\vskip 15pt
\centerline{This program is in the public domain.}

\vskip 30pt
@d PRODUCT "anagram"
@d VERSION "1.5"
@d REVDATE "2019-08-08"

@*1 Command line.
\bigskip
\.{ANAGRAM} is invoked with a command line as follows:
\medskip
\hskip 6em \.{anagram} {\it options $[$\.{'}target phrase\.{'}$]$ $[$seed$\ldots$$]$}
\medskip
\noindent where {\it options} specify processing modes as defined below
and are either long names beginning with two hyphens or single
letter abbreviations introduced by a single hyphen.  The {\it target phrase}
is the phrase for which anagrams will be sought.  If one or more
{\it seed} words is given, only anagrams containing all of those words
will be shown.  The target and seed may be specified by options or
CGI program environment variables as well as on the command line.

@*1 Options.

Options are specified on the command line prior to the input and
output file names (if any).  Options may appear in any order.  Long
options beginning with ``\.{--}'' may be abbreviated to any
unambiguous prefix; single-letter options introduced by a single ``\.{-}''
may be aggregated.

\bigskip

\def\opt#1#2{\vbox{\noindent {\.{#1}}\par
    \vbox{\leftskip=8em\noindent#2}\smallskip}}

\opt{--all}{Generate all anagrams in \.{--cgi} \.{--step} 2.}

\opt{--bail}{Bail out after the first anagram found containing a word.
    In many cases this drastically reduces the time required
    to run the program.  You can review the list of words
    appearing in anagrams and then request a complete list
    of anagrams containing ``interesting'' ones.}

\opt{--bindict{\rm, }-b {\it file}}{Load binary dictionary from {\it file}.
    The default binary dictionary is \.{wordlist.bin}.}

\opt{--cgi}{When executed as a CGI program on a Web server, set
    options from form fields.  These
    settings may be overridden by command line options which
    follow \.{--cgi}.}

\opt{--copyright}{Print copyright information.}

\opt{--dictionary{\rm, }-d {\it file}}{Load word list from {\it file}.
    This is (only) used with the \.{--export} option to compile a
    word list into a binary dictionary.  The default word list
    is \.{crossword.txt}.}

\opt{--export {\it file}}{Create a binary dictionary {\it file} from the
    word list specified by the \.{--dictionary} option of the default
    \.{crossword.txt}.}

\opt{--help{\rm, }-u}{Print how-to-call information including a
    list of options.}

\opt{--html}{Generate HTML output when run as a CGI program on a Web
    server.  The HTML is based on the template file specified by
    the \.{--template} option, which defaults to a file named
    \.{template.html} in the current directory.}

\opt{--permute{\rm, }-p '{\it phrase}'}{Print all permutations of words in the
    given {\it phrase}.  The phrase must be quoted so that blanks
    separating words are considered part of the single {\it phrase}
    argument.}

\opt{--seed{\rm, }-s {\it word}}{Find only anagrams which contain the
    specified {\it word}.  You may specify as many seed words as
    you wish (each with a separate \.{--seed} option) to restrict the
    anagrams to those containing all of the seed words.  To
    obtain a list of words which appear in anagrams of a phrase,
    specify the \.{--bail} option.  You can also specify seed words
    on the command line after the options and target phrase, if any.}

\opt{--step {\it number}}{Perform step {\it number} when operating as a
    CGI program on a Web server.  Step 0, the default, selects non-CGI
    operation; the program acts as a command line utility.  In step 1,
    a list of words appearing in anagrams is generated.  Step 2 generates
    anagrams in which a selected word appears (or, all anagrams
    if the HTML template permits this option).  Step 3 generates all
    permutations of words in a selected anagram.}

\opt{--target{\rm, }-t '{\it phrase}'}{Generate anagrams or permutations for
    the specified {\it phrase}, which must be quoted if it contains more than
    a single word.  If no \.{--target} is specified, the program uses the first
    command line argument as the target.}

\opt{--verbose{\rm, }-v}{Print diagnostic information as the program
    performs various operations.}

\opt{--version}{Print program version information.}

@*1 Using {\tt anagram} as a Web Server CGI Program.

It is possible to install \.{anagram} as a CGI (Common Gateway Interface)
program on a Web server and thereby provide a Web-based anagram finder.
{\bf In most cases this would be extremely unwise!}  It is extremely
easy for an innocent user or pimple-faced denial of service moron
to enter a sequence of letters for which tens of millions of anagrams
exist and thereby lock your server in a CPU-intensive loop for many
minutes, then clog your ISP connection with the enormous results.
Having done so, the latter variety of bottom feeder will immediately
write a script to submit several hundred such requests per second to
your server.

\smallskip
You may think my view of my fellow denizens of Cyberia somewhat
jaundiced, but it is based on the brutal experience of
operating a public Web server since 1994, before which I was
entirely too sanguine about the sanguinary intentions of some
users of freely provided resources. The only circumstances in
which it may make sense to install \.{anagram} on a Web server
are on in-house Intranets where you wish to make the facility
available to users without the need to port the program to all
of the platforms employed by your users, and access logging and
appropriate chastisement with an aluminium baseball bat is
adequate to deal with abuse of the resource.

\smallskip
There are many different Web servers, and even commonly used servers
such as Apache are installed in a multitude of different ways.
Consquently, I can't provide a cookbook procedure for installing
this program as a CGI resource, only templates which can serve as a
point of departure.  I cannot provide any support or assistance in
setting up a Web-based application based on this program---if you
lack the experience required, consult a Webmaster familiar with your
server configuration.

\smallskip
First, you need to build a version of \.{anagram} configured
to execute on your server hardware.  Assuming the server has the proper
compiler installed, this is just a matter of following the regular
build procedure.  Be sure to test the resulting program in normal
command line mode to make sure it works.  If your server is a minimalist
``stripped'' configuration without development tools (as are many ``thin servers''
in ``server farms''), you'll have to build the program on a compatible
development machine then copy it to the server(s).  Be sure to test the
program {\it on the server}---sometimes you'll discover it requires
shared libraries present on the build machine but not the server; if
this occurs, you'll need to either install the libraries on the server
or re-build the application with statically linked libraries (which will
result in a larger program which takes longer to load).

\smallskip
Once you have a version of the program which runs on your server,
copy it to your Web server's \.{cgi-bin} directory.  If you don't know
what this means, you shouldn't be reading this section.

\smallskip
Now you must install a shell script which invokes the \.{anagram} program
with the appropriate options when a client submits a request.  This must
provide the program the complete path for the binary dictionary and the
HTML result template files.  The file \.{cgiweb/AnagramFinder} is
an example of such a script; in most cases you'll need only to change
the \.{HTTPD} declaration at the top to adapt it to your server.

\smallskip
The shell script provides the location of the binary dictionary file
(\.{--bindict}) and HTML template (\.{--template}).  These are usually
kept in a subdirectory of your \.{cgi-bin} directory, but may be
installed in any location accessible by CGI programs.  Copy the
\.{wordlist.bin} binary dictionary from the main distribution directory
and the \.{template.html} file from the \.{cgiweb} subdirectory to the
designated locations.  You'll want to review the latter file to adapt
top links, etc{\null}. for your own site.

\smallskip
Finally, adapt the \.{cgiweb/index.html} page for your site and install it
as the page where users start the anagram generation process.  Test, fix
the myriad obscure bugs attendant to bringing up any new CGI resource,
and you're in business.

@** Program global context.

@c

@h

@<System include files@>@/
@<Program implementation@>@/

@
The following classes are defined and their
implementations provided.

@<Program implementation@>=
@<Global variables@>@/
@<Class definitions@>@/
@<Command line arguments@>@/
@<Class implementations@>@/
@<Global functions@>@/
@<Main program@>@/

@** Dictionary Word.

A |dictionaryWord| is a representation of a string of letters
which facilitates operations common in word games.  When a
|dictionaryWord| is initialised, auxiliary storage is set to
a count of letters (neglecting case and diacritical marks), and
of the type of characters comprising the string.  Operators and
methods permit quick relational tests between objects of this
type.

@<Class definitions@>=
class dictionaryWord {
public:@/
    string text;                    // The word itself
    unsigned char letterCount[26];  // Flattened letter count
    @,@/
    /* The following fields contain counts of characters of
       various classes in the word.  You can use them by themselves
       to test whether a character of the given type is present in
       the word. */
    unsigned int upper,         // Upper case ASCII letters
                 lower,         // Lower case ASCII letters
                 digits,        // Numeric digits
                 spaces,        // White space
                 punctuation,   // Other ASCII characters
                 ISOupper,      // Upper case ISO letters
                 ISOlower,      // Lower case ISO letters
                 ISOpunctuation;// Other ISO characters

    dictionaryWord(string s = "") {
        set(s);
    }

    dictionaryWord(int i) {
        text = "";
        memset(letterCount, 0, sizeof letterCount);
        upper = lower = digits = spaces = punctuation = ISOupper =
                ISOlower = ISOpunctuation = 0;
    }

    void set(string s = "") {
        text = s;
        update();
    }

    string get(void) {
        return text;
    }

    unsigned int length(void) const {     // Return length of word
        return text.length();
    }

    void noBlanks(void) {           // Delete blanks
        string::iterator ep = remove_if(text.begin(), text.end(), &dictionaryWord::is_iso_space);
        text.resize(ep - text.begin());
        update();
    }

    void onlyLetters(void) {        // Delete all non-letters
        string::iterator ep = remove_if(text.begin(), text.end(), &dictionaryWord::is_non_iso_letter);
        text.resize(ep - text.begin());
        update();
    }

    void toLower(void) {            // Convert to lower case
        transform(text.begin(), text.end(), text.begin(), &dictionaryWord::to_iso_lower);
        update();
    }

    void toUpper(void) {            // Convert to upper case
        transform(text.begin(), text.end(), text.begin(), &dictionaryWord::to_iso_upper);
        update();
    }

    void ISOtoASCII(void);

    void describe(ostream &os = cout);

    bool operator <= (dictionaryWord &w);
    bool operator >  (dictionaryWord &w);
    bool operator >= (dictionaryWord &w);
    bool operator <  (dictionaryWord &w);
    bool operator == (dictionaryWord &w);
    bool operator != (dictionaryWord &w);

    bool contained(const dictionaryWord *wbase, const dictionaryWord *candidate);
    bool contained(const dictionaryWord *wbase, unsigned char *candidate);

    dictionaryWord operator + (dictionaryWord &w);
    dictionaryWord operator - (dictionaryWord &w);

    dictionaryWord operator += (dictionaryWord &w);

    void exportToBinaryFile(ostream &os);

protected:@/
    void countLetters(void);

    void update(void) {
        memset(letterCount, 0, sizeof letterCount);
        upper = lower = digits = spaces = punctuation = ISOupper =
                ISOlower = ISOpunctuation = 0;
        countLetters();
    }

    @<Transformation functions for algorithms@>;
};

@
The |countLetters| method prepares the letter count table,
counting characters by class as it goes.

@<Class implementations@>=
    void dictionaryWord::countLetters(void) {
        const unsigned char *cp = (unsigned char *) text.c_str();
        unsigned int c;

        G_clear();

        while ((c = *cp++) != 0) {
            if (c >= 'A' && c <= 'Z') {
                letterCount[c - 'A']++;
            } else if (c >= 'a' && c <= 'z') {
                letterCount[c - 'a']++;
            }
            (*(letter_category[c]))++;
#ifdef ISO_NEEDED
            if (c >= 0xA0) {
                const char *flat = flattenISO[((unsigned char) c) - 0xA0];
                while ((c = *flat++) != 0) {
                    if (islower(c)) {
                        c = toupper(c);
                    }
                    letterCount[c - 'A']++;
                }
            }
#endif
        }

        lower = G_lower;
        upper = G_upper;
        digits = G_digits;
        spaces = G_spaces;
        punctuation = G_punctuation;
        ISOlower = G_ISOlower;
        ISOupper = G_ISOupper;
        ISOpunctuation = G_ISOpunctuation;
    }

@
Sometimes we wish to explicitly flatten ISO accented characters
in a string to their ASCII equivalents.  This method accomplishes
this.  Note that this makes sense primarily for accented letters;
other characters are transformed more or less plausibly, but the
results won't make sense for most word games.

@<Class implementations@>=
    void dictionaryWord::ISOtoASCII(void) {
        for (string::iterator p = text.begin(); p != text.end(); p++) {
            if (((unsigned char) *p) >= 0xA0) {
                int n = p - text.begin();
                unsigned int c = ((unsigned char) *p) - 0xA0;
                text.replace(p, p + 1, flattenISO[c]);
                p = text.begin() + n + (strlen(flattenISO[c]) - 1);
            }
        }
    }

@
The |describe| method writes a human-readable description of the
various fields in the object to the designated output stream,
which defaults to |cout|.

@<Class implementations@>=
    void dictionaryWord::describe(ostream &os) {
        os << text << endl;
        os << "  Total length: " << length() << " characters." << endl;
        for (unsigned int i = 0; i < (sizeof letterCount); i++) {
            if (letterCount[i] > 0) {
                cout << "  " << static_cast<char>(i + 'a') << "  " <<
                    setw(2) << static_cast<int>(letterCount[i]) << endl;
            }
        }
        os << "  ASCII: Letters: " << (upper + lower) << "  (Upper: " <<
            upper << "  Lower: " << lower << ").  Digits: " <<
            digits << "  Punctuation: " << punctuation <<
            "  Blanks: " << spaces << endl;
        os << "  ISO: Letters: " << (ISOupper + ISOlower) << "  (Upper: " <<
            ISOupper << "  Lower: " << ISOlower << ").  Punctuation: " <<
            ISOpunctuation << endl;
    }

@
This method writes a binary representation of the word to an output
stream.  This is used to create the binary word database
used to avoid rebuilding the letter and character category
counts every time.  Each entry begins with the number of
characters in the word follows by its text.  After this,
26 single byte letter counts are written, followed by
8 bytes containing the character category counts.

@<Class implementations@>=
    void dictionaryWord::exportToBinaryFile(ostream &os) {
        unsigned char c;

#define outCount(x) c = (x); os.put(c)

        outCount(text.length());
        os.write(text.data(), text.length());

        for (unsigned int i = 0; i < sizeof letterCount; i++) {
            os.put(letterCount[i]);
        }

        outCount(upper);
        outCount(lower);
        outCount(digits);
        outCount(spaces);
        outCount(punctuation);
        outCount(ISOupper);
        outCount(ISOlower);
        outCount(ISOpunctuation);

#undef outCount
    }

@
We define the relational operators in a rather curious way.  They test
whether a word is ``contained'' within another in terms of the count of
letters it contains.  A word is {\it less} than another if it contains
fewer of every letter.  For example ``{\it bet}'' is less than ``{\it beet}''
because it contains only one ``{\it e}''.  This definition of magnitude is
extremely useful in a variety of word games, as it permits quick rejection
of inapplicable solutions.

Since the various operator implementations differ only in the
relational operator applied across the |letterCount| arrays of
the two arguments, we can stamp out the code cookie-cutter
style with a macro.

@s dictionaryWordComparisonOperator int
@d dictionaryWordComparisonOperator(op)
    bool dictionaryWord::operator @, op @, (dictionaryWord &w) {
        for (unsigned int i = 0; i  < sizeof letterCount; i++) {
            if (!(letterCount[i] @, op @, w.letterCount[i])) {
                return false;
            }
        }
        return true;
    }

@<Class implementations@>=
    dictionaryWordComparisonOperator(<);@/
    dictionaryWordComparisonOperator(>);@/
    dictionaryWordComparisonOperator(==);@/
    dictionaryWordComparisonOperator(!=);@/
    dictionaryWordComparisonOperator(<=);@/
    dictionaryWordComparisonOperator(>=);@/
@
Addition and subtraction are defined as concatenation of strings for
addition and deletion of characters in the right hand operand
from the left hand string (with, in both cases, recomputation of
the parameters).  The |+=| operator is implemented in a particularly
efficient manner since we don't need to re-count the letters
and categories---they may simply be summed in place.

@<Class implementations@>=
    dictionaryWord dictionaryWord::operator + (dictionaryWord &w) {
        dictionaryWord result(text + w.text);
        return result;
    }

    dictionaryWord dictionaryWord::operator += (dictionaryWord &w) {
        text += w.text;
        for (unsigned int i = 0; i  < sizeof letterCount; i++) {
            letterCount[i] += w.letterCount[i];
        }
        lower += w.lower;
        upper += w.upper;
        digits += w.digits;
        spaces += w.spaces;
        punctuation += w.punctuation;
        ISOlower += w.ISOlower;
        ISOupper += w.ISOupper;
        ISOpunctuation += w.ISOpunctuation;
        return *this;
    }

    dictionaryWord dictionaryWord::operator - (dictionaryWord &w) {
        dictionaryWord result = *this;

        for (string::iterator p = w.text.begin(); p != w.text.end(); p++) {
            string::size_type n = result.text.find(*p);
            if (n != string::npos) {
                result.text.erase(n, 1);
            }
        }
        return result;
    }

@
This is a kludge.  When searching for anagrams and other such transformations,
we often wish to know whether a candidate word or phrase is ``contained''
within another.  Containment is defined as having counts for all letters
less than or equal to that of the target phrase.  This test can be
accomplished straightforwardly by generating a |dictionaryWord| for the
candidate and then testing with our relational operators, but that
clean approach can consume enormous amounts of time when you're
testing lots of candidates.  This special purpose method is passed
pointers to two |dictionaryWord|s which are logically concatenated
(which is what we need when testing potential anagrams---if you're
testing only one letter sequence, pass a pointer to an empty word
for the second argument.  The argument words are tested for containment
against the word in the object and a Boolean result is immediately
returned.  No recomputation of letter counts need be done.

@<Class implementations@>=
    bool dictionaryWord::contained(const dictionaryWord *wbase,
                                   const dictionaryWord *candidate) {
        for (unsigned int i = 0; i  < sizeof letterCount; i++) {
            if ((wbase->letterCount[i] + candidate->letterCount[i]) >
                    letterCount[i]) {
                return false;
            }
        }
        return true;
    }


@
This is a version of the |contained| method which directly uses a
pointer into the binary dictionary.  This avoids the need to
construct a |dictionaryWord| for the candidate, but rather tests
the letter counts ``just sitting there'' in the binary dictionary
item.

@<Class implementations@>=
    bool dictionaryWord::contained(const dictionaryWord *wbase,
                                   unsigned char *candidate) {
        unsigned char *lc = binaryDictionary::letterCount(candidate);

        for (unsigned int i = 0; i  < sizeof letterCount; i++) {
            if ((wbase->letterCount[i] + lc[i]) >
                    letterCount[i]) {
                return false;
            }
        }
        return true;
    }

@
The following are simple-minded transformation functions passed
as arguments to STL algorithms for various manipulations of the
text.

@<Transformation functions for algorithms@>=
    static bool is_iso_space(char c) {
        return isspace(c) || (c == '\xA0');
    }

    static bool is_non_iso_letter(char c) {
        return !isISOalpha(c);
    }

    static char to_iso_lower(char c) {
        return toISOlower(c);
    }

    static char to_iso_upper(char c) {
        return toISOupper(c);
    }

@** Dictionary.

A |dictionary| is simply a collection of |dictionaryWord|s.  You can
extract individual words or perform wholesale operations on
dictionaries.  The |dictionary| is defined as an extension of the
template class |vector <dictionaryWord>|, inheriting and making
public all of its functionality.  All of the STL methods and
algorithms which apply to a |vector| will work with a
|dictionary| in the same manner.

@
First of all, we need to introduce a silly little class which
compares two dictionary entries by length which is needed by
the |sortByDescendingLength| method defined below.

@<Class definitions@>=
class dlencomp {
public:@/
    int operator() (const dictionaryWord &a, const dictionaryWord &b) const {
        return a.length() > b.length();
    }
};

@
Okay, now that {\it that's} out of the way, we can get on with
the serious business.  Here's the |dictionary| class definition.

@<Class definitions@>=
class dictionary : public vector <dictionaryWord> {
public:@/
    void loadFromFile(istream &is, bool punctuationOK = true,
                      bool digitsOK = true) {
        string s;

        while (getline(is, s)) {
            dictionaryWord w(s);
            if ((punctuationOK ||
                 ((w.punctuation == 0) &&
                  (w.spaces == 0) &&
                  (w.ISOpunctuation == 0))) &&
                 (digitsOK || (w.digits == 0))
                ) {
                push_back(dictionaryWord(s));
            }
        }

        if (verbose) {
            cerr << "Loaded " << size() << " words from word list." << endl;
        }
    }

    void describe(ostream &os = cout) {
        vector<dictionaryWord>::iterator p;
        for (p = begin(); p != end(); p++) {
            cout << p->text << endl;
        }
    }

    void sortByDescendingLength(void) {
        stable_sort(begin(), end(), dlencomp());
    }

    void exportToBinaryFile(ostream &os);
};

@
To avoid the need to reconstruct the dictionary from its
text-based definition, we can export the dictionary as a binary file.
This method simply iterates over the entries in the dictionary,
asking each to write itself to the designated binary dictionary
file.  A zero byte is written at the end to mark the end of
the table (this is the field which would give the length of
the next word).  The first four bytes of the binary dictionary
file contain the number of entries in big-endian order.

@<Class implementations@>=
    void dictionary::exportToBinaryFile(ostream &os) {
        unsigned long nwords = size();

        os.put(nwords >> 24);
        os.put((nwords >> 16) & 0xFF);
        os.put((nwords >> 8) & 0xFF);
        os.put(nwords & 0xFF);

        vector<dictionaryWord>::iterator p;

        for (p = begin(); p != end(); p++) {
            p->exportToBinaryFile(os);
        }
        os.put(0);
        if (verbose) {
            cerr << "Exported " << nwords << " to " <<
                os.tellp() << " byte binary dictionary." << endl;
        }
    }


@** Binary Dictionary.

The binary dictionary accesses a pre-sorted and -compiled dictionary which
is accessed as a shared memory mapped file.  The {\it raison d'\^etre} of
the binary dictionary is speed, so the methods used to access it are
relatively low-level in the interest of efficiency.  For example, copying
of data is avoided wherever possible, either providing pointers the user
can access directly or setting fields in objects passed by the caller by
pointer.

The binary dictionary is created by the \.{--export} option of this
program, by loading a word list and then writing it as a binary
dictionary with the |dictionary::exportToBinaryFile| method.

@<Class definitions@>=
class binaryDictionary {
public:@/
    long flen;                          // File length in bytes
    unsigned char *dict;                // Memory mapped dictionary
    int fileHandle;                     // File handle for dictionary
    unsigned long nwords;               // Number of words in dictionary

    static const unsigned int letterCountSize = 26,
                              categoryCountSize = 8;

    void loadFromFile(string s) {
        @<Bring binary dictionary into memory@>;
    }

    binaryDictionary() {
        fileHandle = -1;
        dict = NULL;
    }

    ~binaryDictionary() {
#ifdef HAVE_MMAP
        if (fileHandle != -1) {
            munmap(reinterpret_cast<char *>(dict), flen);
            close(fileHandle);
        }
#else
        if (dict != NULL) {
            delete dict;
        }
#endif
    }

    void describe(ostream &os = cout) {
    }

    static unsigned int itemSize(unsigned char *p) {    // Return item size in bytes
        return p[0] + 1 + letterCountSize + categoryCountSize;
    }

    unsigned char *first(void) {        // Pointer to first item
        return dict + 4;                // Have to skip number of words
    }

    static unsigned char *next(unsigned char *p) { // Pointer to item after this one
        p += itemSize(p);
        return (*p == 0) ? NULL : p;
    }

    static unsigned char *letterCount(unsigned char *p) {
        // Pointer to letter count table for item
        return p + p[0] + 1;
    }

    static unsigned char *characterCategories(unsigned char *p) {
        // Pointer to character category table
        return letterCount(p) + letterCountSize;
    }

    static unsigned int length(unsigned char *p) {          // Get text length
        return p[0];
    }

    static void getText(unsigned char *p, string *s) {      // Assign text value to string
        s->assign(reinterpret_cast<char *>(p + 1), p[0]);
    }

    static void setDictionaryWordCheap(dictionaryWord *w, unsigned char *p) {
        getText(p, &(w->text));
        memcpy(w->letterCount, letterCount(p), letterCountSize);
    }

    //  Offsets of fields in the letter category table

    static const unsigned int C_upper = 0, C_lower = 1, C_digits = 2,
        C_spaces = 3, C_punctuation = 4, C_ISOupper = 5,
        C_ISOlower = 6, C_ISOpunctuation = 7;

    static void printItem(unsigned char *p, ostream &os = cout);

    void printDictionary(ostream &os = cout);
};

@
Since we're going to access the binary dictionary intensively
(via the auxiliary dictionary's pointers), we need to load it
into memory.  The preferred means for accomplishing this is to
memory map the file containing the dictionary into our address
space and delegate management of it in virtual memory to the
system.   There's no particular benefit to this if you're running
the program sporadically as a single user, but in server applications
such as a CGI script driving the program, memory mapping
with the |MAP_SHARED| attribute can be a huge win, since the
database is shared among all processes requiring it and, once
brought into virtual memory, need not be reloaded when subsequent
processes require it.

But of course not every system supports memory mapping.  Our
\.{autoconf} script detects whether the system supports the
|mmap| function and, if not, sets a configuration variable which
causes us to fall back on reading the dictionary into a dynamically
allocated memory buffer in the process address space.

@<Bring binary dictionary into memory@>=
        FILE *fp;

        fp = fopen(s.c_str(), "rb");
        if (fp == NULL) {
            cout << "Cannot open binary dictionary file " << s << endl;
            exit(1);
        }
        fseek(fp, 0, 2);
        flen = ftell(fp);
#ifndef HAVE_MMAP
        dict = new unsigned char[flen];
        rewind(fp);
        fread(dict, flen, 1, fp);
#endif
        fclose(fp);
#ifdef HAVE_MMAP
        fileHandle = open(s.c_str(), O_RDONLY);
        dict = reinterpret_cast<unsigned char *>(mmap((caddr_t) 0, flen,
                PROT_READ, MAP_SHARED | MAP_NORESERVE,
                fileHandle, 0));
#endif
        nwords = (((((dict[0] << 8) | dict[1]) << 8) | dict[2]) << 8) | dict[3];
        if (verbose) {
            cerr << "Loaded " << nwords << " words from binary dictionary " << s << "." << endl;
        }


@
|printItem| prints a human readable representation of the item
its argument points to on the designated output stream.

@<Class implementations@>=
    void binaryDictionary::printItem(unsigned char *p, ostream &os) {
        unsigned int textLen = *p++;
        string text(reinterpret_cast<char *>(p), textLen);

        os << text << endl;
        p += textLen;

        for (unsigned int i = 0; i < letterCountSize; i++) {
            unsigned int n = *p++;
            if (n > 0) {
                os << "  " << static_cast<char>('a' + i) << "  " << setw(2) << n << endl;
            }
        }

        unsigned int upper, lower, digits, spaces, punctuation,
                     ISOupper, ISOlower, ISOpunctuation;

        upper = *p++;
        lower = *p++;
        digits = *p++;
        spaces = *p++;
        punctuation = *p++;
        ISOupper = *p++;
        ISOlower = *p++;
        ISOpunctuation = *p;

        os << "  ASCII: Letters: " << (upper + lower) << "  (Upper: " <<
            upper << "  Lower: " << lower << ").  Digits: " <<
            digits << "  Punctuation: " << punctuation <<
            "  Blanks: " << spaces << endl;
        os << "  ISO: Letters: " << (ISOupper + ISOlower) << "  (Upper: " <<
            ISOupper << "  Lower: " << ISOlower << ").  Punctuation: " <<
            ISOpunctuation << endl;

    }

@
To print the entire dictionary, we simply iterate over the entries and
ask each to print itself with |printItem|.

@<Class implementations@>=
    void binaryDictionary::printDictionary(ostream &os) {
        unsigned char *p = first();

        while (p != NULL) {
            printItem(p, os);
            p = next(p);
        }
    }


@** Main program.

The main program is rather simple.  We initialise the letter
category table, analyse the command line, and then do whatever
it asked us to do.

@<Main program@>=

int main(int argc, char *argv[])
{
    int opt;

    build_letter_category();

    @<Process command-line options@>;
    @<Verify command-line arguments@>;

    @<Perform requested operation@>;

   return 0;
}

@
The global variable |cgi_step| tells us what we're expected to do
in this session.  If 0, this is a command-line invocation to generate
all the anagrams for the target (or just a list of words in anagrams
if \.{--bail} is set).  Otherwise, this is one of the three phases
of CGI script processing.  In the first phase, we generate a
table of words appearing in anagrams.  In the second, we generate
anagrams containing a selected word (or all anagrams, if the
HTML template admits that option and the box is checked).  In the
third, we display all the permutations of words in a selected
anagram; for this step the dictionary is not required and is not
loaded.

@<Perform requested operation@>=
    if (exportfile != "") {
        @<Build the binary dictionary from a word list@>;
    }

    dictionaryWord w(target);
    w.onlyLetters();
    w.toLower();

    @<Load the binary dictionary if required@>;

    switch (cgi_step) {
        case 0:                         // Non-CGI---invoked from the command line
            {
                direct_output = true;
                @<Specify target from command line argument if not already specified@>;
                if (permute) {
                    @<Generate permutations of target phrase@>;
                } else {
                    @<Find anagrams for word@>;
                }
            }
            break;

        case 1:                         // Initial request for words in anagrams
            bail = true;
            @<Find anagrams for word@>;
            generateHTML(cout, '2');
            break;

        case 2:                         // Request for anagrams beginning with given word
            @<Find anagrams for word@>;
            generateHTML(cout, '3');
            break;

        case 3:                         // Request for permutations of a given anagram
            generateHTML(cout);
            break;
    }

@
If the requested operation requires the binary dictionary, load
it from the file. After loading the binary dictionary, an
auxiliary dictionary consisting of pointers to items in the
binary dictionary which can appear in anagrams of the target
|w| is built with |build_auxiliary_dictionary|.

@<Load the binary dictionary if required@>=
    binaryDictionary bdict;

    if ((cgi_step < 3) && (!permute)) {
        if (bdictfile != "") {
            bdict.loadFromFile(bdictfile);
        }
    }

@
When the \.{--export} option is specified, we load the word list
file given by the \.{--dictionary} option (or the default),
filter and sort it as required, and write it in binary dictionary
format.  The program immediately terminates after creating the
binary dictionary.

@<Build the binary dictionary from a word list@>=
    dictionary dict;

    ofstream os(exportfile.c_str(), ios::binary | ios::out);
    ifstream dif(dictfile.c_str());
    dict.loadFromFile(dif, false, false);
    dict.sortByDescendingLength();

#ifdef DICTECHO
    {
        ofstream es("common.txt");
        for (int i = 0; i < dict.size(); i++) {
            es << dict[i].text << endl;
        }
        es.close();
    }
#endif

    dict.exportToBinaryFile(os);
    os.close();
    return 0;

@
If the user has not explicitly specified the target with the
\.{--target} option, obtain it from the first command line
argument, if any.

@<Specify target from command line argument if not already specified@>=
    if ((optind < argc) && (target == "")) {
        target = argv[optind];
        w.set(target);
        w.onlyLetters();
        w.toLower();
        optind++;
    }

@
To find the anagrams for a given word, we walk through the dictionary
in a linear fashion and use the relational operators on the
letter count tables to test ``containment''.  A dictionary word is
{\it contained} within the target phrase if it has the same number
or fewer of each letter in the target, and no letters which do not
appear in the target.

@<Find anagrams for word@>=
    build_auxiliary_dictionary(&bdict, &w);

    if (optind < argc) {
        for (int n = optind; n < argc; n++) {
            dictionaryWord *given = new dictionaryWord(argv[n]);
            seed = seed + *given;
            anagram.push_back(given);
        }
        if ((seed <= w) && (!(seed > w))) {
            anagram_search(w, anagram, 0, bail, bail ? 0 : -1);
        } else {
            cerr << "Seed words are not contained in target." << endl;
            return 2;
        }
    } else if (seed.length() > 0) {
        if ((seed <= w) && (!(seed > w))) {
            anagram_search(w, anagram, 0, bail, bail ? 0 : -1);
        } else {
            cerr << "Seed words are not contained in target." << endl;
            return 2;
        }
    } else {
        for (unsigned int n = 0; n < auxdictl; n++) {
            unsigned char *p = auxdict[n];

            vector <dictionaryWord *> anagram;
            dictionaryWord aw;

            binaryDictionary::setDictionaryWordCheap(&aw, p);
            anagram.push_back(&aw);
            anagram_search(w, anagram, n, bail, bail ? 0 : -1);
        }
    }

@
When the \.{--permute} option is specified, load words from the target
phrase into the |permutations| vector and generate and output
the permutations.

@<Generate permutations of target phrase@>=
    @<Load words of target into permutations vector@>;
    @<Enumerate and print permutations@>;

@
Walk through the target string, extract individual (space separated)
words, and place them in the |permutations| vector.  We're tolerant
of extra white space at the start, end, or between words.

@<Load words of target into permutations vector@>=
    bool done = false;
    string::size_type pos = target.find_first_not_of(' '), spos;

    while (!done) {
        if ((spos = target.find_first_of(' ', pos)) != string::npos) {
            permutations.push_back(target.substr(pos, spos - pos));
            pos = target.find_first_not_of(' ', spos + 1);
        } else {
            if (pos < target.length()) {
                permutations.push_back(target.substr(pos));
            }
            done = true;
        }
    }

@
Generate all of the permutations of the specified words
and print each.  Note that we must sort |permutations| so
that the permutation generation will know when it's done.

@<Enumerate and print permutations@>=
    int n = permutations.size(), nbang = 1;
    vector<string>::iterator p;

    while (n > 1) {
        nbang *= n--;
    }

    sort(permutations.begin(), permutations.end());
    do {
        for (p = permutations.begin(); p != permutations.end(); p++) {
            if (p != permutations.begin()) {
                dout << " ";
            }
            dout << *p;
        }
        dout << endl;
    } while (next_permutation(permutations.begin(), permutations.end()));

@
Here we collect together the assorted global functions of various
types.

@<Global functions@>=
    @<Character category table initialisation@>;
    @<Auxiliary dictionary construction@>;
    @<Anagram search auxiliary function@>;
    @<HTML generator@>;

@*1 Auxiliary Dictionary.

In almost every case we can drastically speed up the search for
anagrams by constructing an {\it auxiliary dictionary} consisting
of only those words which can possible occur in anagrams of the
target phrase.  Words which are longer, or contain more of a given
letter than the entire target phrase may be immediately
excluded and needn't be tested in the exhaustive search phase.

@<Global variables@>=
    unsigned char **auxdict = NULL;
    unsigned int auxdictl = 0;

@
The process of building the auxiliary dictionary is painfully
straightforward, but the key is that we only have to do it
{\it once}.  We riffle through the word list (which has
already been sorted in descending order by length of word),
skipping any words which, by themselves are longer than the
|target| and hence can't possibly appear in anagrams of it.
Then, we allocate a pointer table as long as the remainder of
the dictionary (which often wastes a bunch of space, but it's
much faster than using a |vector| or dynamically expanding a
buffer as we go) and fill it with pointers to items in the
dictionary which are contained within possible anagrams of
the |target|.  It is this table we'll use when actually searching
for anagrams.

@<Auxiliary dictionary construction@>=
static void build_auxiliary_dictionary(binaryDictionary *bd, dictionaryWord *target) {
    if (auxdict != NULL) {
        delete auxdict;
        auxdict = NULL;
        auxdictl = 0;
    }

    unsigned long i;
    unsigned char *p = bd->first();
    unsigned int tlen = target->length();

    //  Quick reject all entries longer than the target

    for (i = 0; i < bd->nwords; i++) {
        if (binaryDictionary::length(p) <= tlen) {
            break;
        }
        p = binaryDictionary::next(p);
    }

    //  Allocate auxiliary dictionary adequate to hold balance

    if (i < bd->nwords) {
        auxdict = new unsigned char *[bd->nwords - i];

        for (; i < bd->nwords; i++) {
            unsigned char *lc = binaryDictionary::letterCount(p);

            for (unsigned int j = 0; j < binaryDictionary::letterCountSize; j++) {
                if (lc[j] > target->letterCount[j]) {
                    goto busted;
                }
            }
            auxdict[auxdictl++] = p;
busted:;
            p = binaryDictionary::next(p);
        }
    }
}

@*1 Anagram Search Engine.

The anagram search engine is implemented by the recursive
procedure |anagram_search|.  It is called with a |dictionaryWord|
set to the target phrase and a vector (initially empty) of pointers
to |dictionaryWord|s which are candidates to appear in anagrams---in
other words, the sum of the individual letter counts of items in the vector
are all less than or equal than those of the target phrase.

On each invocation, it searches the auxiliary dictionary (from which
words which cannot possibly appear in anagrams of the target because
their own letter counts are not contained in it) and, upon finding
a word which, added to the words with which the function was invoked,
is still contained within the target, adds the new word to the
potential anagram vector and recurses to continue the process.  The
process ends either when an anagram is found (in which case it is emitted
to the designated destination) or when no word in the auxiliary dictionary,
added to the words already in the vector, can be part of an anagram of the
target.  This process continues until the outer-level search reaches the
end of the dictionary, at which point all anagrams have been found.

If the |bail| argument is |true|, the stack will be popped and the
top level dictionary search resumed with the next dictionary word.

@<Global variables@>=
    vector <string> anagrams;
    vector <string> firstwords;
    vector <string> anagrams_for_word;
    vector <string> permutations;

@
@<Anagram search auxiliary function@>=
static bool anagram_search(dictionaryWord &target, vector <dictionaryWord *> &a,
    unsigned int n,
    bool bail = false, int prune = -1) {

@
Assemble the base word from the contained words in the candidate stack.
In the interest of efficiency (remember that this function can be
called recursively millions of times in a search for anagrams of a
long phrase with many high-frequency letters), we explicitly add the
letter counts for the words rather than using the methods in
|dictionaryWord| which compute character class counts we don't need
here.

@<Anagram search auxiliary function@>=
    vector<dictionaryWord *>::size_type i;
    dictionaryWord wbase(0);

    for (i = 0; i < a.size(); i++) {
        wbase.text += a[i]->text;
        for (unsigned int j = 0; j < binaryDictionary::letterCountSize; j++) {
            wbase.letterCount[j] += a[i]->letterCount[j];
        }
    }

@
The first thing we need to determine is if we're {\it already
done}; in other words, is the existing base word itself an
anagram.  This test is just a simple test for equality of letter
counts.

@<Anagram search auxiliary function@>=
    if (memcmp(target.letterCount, wbase.letterCount,
            binaryDictionary::letterCountSize) == 0) {
        string result;
        for (i = 0; i < a.size(); i++) {
            if (i > 0) {
                result += " ";
            }
            result += a[i]->text;
            if (static_cast<int>(i) == prune) {
                break;
            }
        }
        if (direct_output) {
            dout << result << endl;
        } else {
            anagrams.push_back(result);
        }
        return true;
    }

@
Okay, we're not done.  The base word consequently contains fewer of one
or more letters than the target.  So, we walk forward through the
dictionary starting with the current word (the one just added to the
base) until the end.  For each dictionary word, we test whether the
base phrase with that word concatenated at the end remains contained
within the target or if it ``goes bust'' either by containing a letter
not in the target or too many of one of the letters we're still looking
for.

@<Anagram search auxiliary function@>=
    for ( ; n < auxdictl; n++) {
        unsigned char *p = auxdict[n];

        if ((wbase.length() + binaryDictionary::length(p)) <= target.length()) {
            if (target.contained(&wbase, p)) {
                dictionaryWord aw;

                binaryDictionary::setDictionaryWordCheap(&aw, p);
                a.push_back(&aw);
                bool success = anagram_search(target, a, n, bail, prune);
                a.pop_back();
                if (bail && success) {
                    return (a.size() > 1);
                }
            }
        }
    }

    return false;
}

@*1 HTML Generator.

The HTML generator creates an HTML result page containing the anagrams
or permutations requested by the user.  It operates by copying a
``template'' file to the designated output stream, interpolating variable
content at locations indicated by markers embedded in the template.

@<HTML generator@>=
static void generateHTML(ostream &os, char stopAt = 0)
{
    ifstream is(HTML_template.c_str());
    string s;
    bool skipping = false;

    while (getline(is, s)) {
        if (s.substr( 0, 5) == "<!-- ") {
            @<Process meta-command in HTML template@>;
        } else {
            if (!skipping) {
                os << s << endl;
            }
        }
    }
}

@
HTML comments beginning in column 1 are used as meta-commands
for purposes such as marking sections of the file to be skipped
and to trigger the inclusion of variable content.

@<Process meta-command in HTML template@>=
    if (s[5] == '@@') {
        @<Process include meta-command@>;
    } else {
        @<Process section marker meta-command@>;
    }

@
As the interaction with the user progresses, we wish to include
additional steps in the HTML reply returned.  The template
file includes section markers between each step in the interaction.
If the |stopAt| argument matches the character in the section
marker, the balance of the file is skipped until the
special ``\.{X}'' section marker at the bottom is encountered.

@<Process section marker meta-command@>=
    if (s[5] == 'X') {
        skipping = false;
    } else if (s[5] == stopAt) {
        skipping = true;
    }

@
Meta-commands which begin with ``\.{@@}'' trigger inclusion of variant
material in the file, replacing the marker.  Naturally, we process these
includes only when we aren't skipping sections in the file.

@<Process include meta-command@>=
    if (!skipping) {
        switch (s[6]) {
            case '1':@/
                os << "    value=\"" << target << "\"" << endl;
                break;

            case '2':
                @<Generate first word selection list@>;
                break;

            case '3':@/
                @<Generate first word hidden argument@>;
                break;

            case '4':@/
                @<Generate list of anagrams containing specified word@>;
                break;

            case '5':@/
                @<Generate all permutations of selected anagram@>;
                break;

            case '6':@/
                @<Generate pass-on of target and firstwords to subsequent step@>;
                @<Generate pass-on of anagrams generated in step 2@>;
                break;
        }
    }

@
The following code generates the list used to select the set of anagrams to
be generated based on a word it contains.  In the first phase of processing,
this is simply the pruned results from the dictionary search.  Subsequently,
the list is simply parroted from a \.{hidden} form field passed in from
the previous step.

@<Generate first word selection list@>=
    {   vector<string> &svec =  (cgi_step == 1) ? anagrams : firstwords;

        vector<string>::size_type nfound = svec.size();
        if (nfound > 12) {
            nfound = 12;
        }
        os << "    size=" << nfound << ">" << endl;
        for (vector<string>::iterator p = svec.begin();
             p != svec.end(); p++) {
            os << "    <option>" << *p << endl;
        }
    }

@
Polly want a crude hack?  Here's where we generate the list of first words which
subsequent steps parrot to populate the first word selection box.  If we're
in a subsequent step this is, in turn parroted from the preceding step.

@<Generate first word hidden argument@>=
    {   vector<string> &svec =  (cgi_step == 1) ? anagrams : firstwords;

        os << "<input type=\"hidden\" name=\"target\" value=\"" << target << "\">" << endl;
        os << "<input type=\"hidden\" name=\"firstwords\" value=\"";
        for (vector<string>::iterator p = svec.begin();
             p != svec.end(); p++) {
            if (p != svec.begin()) {
                os << ",";
            }
            os << *p;
        }
        os << "\">" << endl;
    }

@
Here we emit the list of anagrams which contain a word chosen from the
list of words in step 2.  As with the table of first words above, we
either emit these words from the |anagrams| vector if we're in
step 2 or from the canned |anagrams_for_word| in subsequent steps.

@<Generate list of anagrams containing specified word@>=
    {   vector<string> &svec =  (cgi_step == 2) ? anagrams : anagrams_for_word;

        vector<string>::size_type nfound = svec.size();
        if (nfound > 12) {
            nfound = 12;
        }
        os << "    size=" << nfound << ">" << endl;
        for (vector<string>::iterator p = svec.begin();
             p != svec.end(); p++) {
            os << "    <option>" << *p << endl;
        }
    }

@
In steps subsequent to 1, we need to preserve the target and list of first words
selection box.  This code generates hidden input fields to pass these values
on to subsequent steps.

@<Generate pass-on of target and firstwords to subsequent step@>=
    {
        os << "<input type=\"hidden\" name=\"target\" value=\"" << target << "\">" << endl;
        os << "<input type=\"hidden\" name=\"firstwords\" value=\"";
        for (vector<string>::iterator p = firstwords.begin();
             p != firstwords.end(); p++) {
            if (p != firstwords.begin()) {
                os << ",";
            }
            os << *p;
        }
        os << "\">" << endl;
    }

@
Similarly, in steps 2 and later we need to pass on the anagrams
generated by step 2.  We also output these as a hidden input
field.

@<Generate pass-on of anagrams generated in step 2@>=
    {   vector<string> &svec =  (cgi_step == 2) ? anagrams : anagrams_for_word;

        os << "<input type=\"hidden\" name=\"anagrams\" value=\"";
        for (vector<string>::iterator p = svec.begin();
             p != svec.end(); p++) {
            if (p != svec.begin()) {
                os << ",";
            }
            os << *p;
        }
        os << "\">" << endl;
    }

@
When the user selects one of the anagrams presented in step 3
and proceeds to step 4, we prepare a list of all possible permutations
of the anagram.  The user's gotta be pretty lazy not to be able
to to this in his head, but what the heck, {\it many} Web users
are lazy!  Besides, STL's |next_permutation| algorithm does
all the work, so even a lazy implementor doesn't have to
overexert himself.

Before the table of permutations, we emit the \.{rows=}
specification and close the \.{textarea} tag.  For a list
of $n$ items there are $n!$ permutations, so we compute the
factorial and size the box accordingly.

@<Generate all permutations of selected anagram@>=
    {
        int n = permutations.size(), nbang = 1, cols = 1;
        vector<string>::iterator p;

        while (n > 1) {
            nbang *= n--;
        }
        for (p = permutations.begin(); p != permutations.end(); p++) {
            if (p != permutations.begin()) {
                cols++;
            }
            cols += p->length();
        }
        cout << "cols=" << cols << " rows=" << nbang << ">" << endl;

        sort(permutations.begin(), permutations.end());
        do {
            for (p = permutations.begin(); p != permutations.end(); p++) {
                if (p != permutations.begin()) {
                    os << " ";
                }
                os << *p;
            }
            os << endl;
        } while (next_permutation(permutations.begin(), permutations.end()));
    }

@
The following include files provide access to system and
library components.

@<System include files@>=
#include "config.h"

#include <iostream>
#include <iomanip>
#include <fstream>
#include <cstdlib>
#include <string>
#include <vector>
#include <algorithm>
using namespace std;

#include <stdio.h>
#include <fcntl.h>
#include <ctype.h>
#include <string.h>

#ifdef HAVE_STAT
#include <sys/stat.h>
#endif
#ifdef WIN32
//  Lazy way to avoid manually modifying config.h for Win32 builds
#ifdef HAVE_UNISTD_H
#undef HAVE_UNISTD_H
#endif
#undef HAVE_MMAP
#endif
#ifdef HAVE_MMAP
#include <sys/mman.h>
#endif
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

#include "getopt.h"     // Use our own |getopt|, which supports |getopt_long|

extern "C" {
    void uncgi(void);   // We use |uncgi| to transform CGI arguments into environment variables
}

@
Here are the global variables we use to keep track of command
line options.

@<Command line arguments@>=
#ifdef NEEDED
static bool flattenISOchars = false;    // Flatten ISO 8859-1 8-bit codes to ASCII
#endif
static bool bail = false;               // Bail out on first match for a given word
static string dictfile = "crossword.txt";       // Dictionary file name
static string bdictfile = "wordlist.bin"; // Binary dictionary file
static string exportfile = "";          // Export dictionary file name
static string target = "";              // Target phrase
static dictionaryWord seed("");         // Seed word
static dictionaryWord empty("");        // Empty |dictionaryWord|
static vector <dictionaryWord *> anagram; // Anagram search stack
static int cgi_step = 0;                // CGI processing step or 0 if not CGI-invoked
static bool cgi_all = false;            // Generate all anagrams in CGI step 2
static bool html = false;               // Generate HTML output ?
static string HTML_template = "template.html";  // Template for HTML output
static bool direct_output = false;      // Write anagrams directly to stream ?
static ostream &dout = cout;            // Direct output stream
static bool permute = false;            // Generate permutations of target

@
The following options are referenced in class definitions and must
be placed in the |@<Global variables@>| section so they'll be declared
first.

@<Global variables@>=
static bool verbose = false;            // Print verbose processing information

@ Procedure |usage|
prints how-to-call information.  This serves as a reference for the
option processing code which follows.  Don't forget to update
|usage| when you add an option!

@<Global functions@>=
static void usage(void)
{
    cout << PRODUCT << "  --  Anagram Finder.  Call\n";
    cout << "             with "<< PRODUCT << " [options] 'phrase' [contained words]\n";
    cout << "\n";
    cout << "Options:\n";
    cout << "    --all                  Generate all anagrams in CGI step 2\n";
    cout << "    --bail                 Bail out after first match for a given word\n";
    cout << "    --bindict, -b file     Use file as binary dictionary\n";
    cout << "    --cgi                  Set options from uncgi environment variables\n";
    cout << "    --copyright            Print copyright information\n";
    cout << "    --dictionary, -d file  Use file as dictionary\n";
    cout << "    --export file          Export binary dictionary file\n";
#ifdef NEEDED
    cout << "    --flatten-iso          Flatten ISO 8859-1 8-bit codes to ASCII\n";
#endif
    cout << "    --help, -u             Print this message\n";
    cout << "    --html                 Generate HTML output\n";
    cout << "    --permute, -p          Generate permutations of target\n";
    cout << "    --seed, -s word        Specify seed word\n";
    cout << "    --step number          CGI processing step\n";
    cout << "    --target, -t phrase    Target phrase\n";
    cout << "    --template             Template for HTML output\n";
    cout << "    --verbose, -v          Print processing information\n";
    cout << "    --version              Print version number\n";
    cout << "\n";
    cout << "by John Walker\n";
    cout << "http://www.fourmilab.ch/\n";
}

@
We use |getopt_long| to process command line options.  This
permits aggregation of single letter options without arguments and
both \.{-d}{\it arg} and \.{-d} {\it arg} syntax.  Long options,
preceded by \.{--}, are provided as alternatives for all single
letter options and are used exclusively for less frequently used
facilities.

@<Process command-line options@>=
    @q *** DID YOU REMEMBER TO ADD THE OPTION TO USAGE()? *** @>
    static const struct option long_options[] = {@/
        { "all", 0, NULL, 206 },@/
        { "bail", 0, NULL, 208 },@/
        { "bindict", 1, NULL, 'b' },@/
        { "cgi", 0, NULL, 202 },@/
        { "copyright", 0, NULL, 200 },@/
        { "dictionary", 1, NULL, 'd' },@/
        { "export", 1, NULL, 207 },@/
#ifdef NEEDED
        { "flatten-iso", 0, NULL, 212 },@/
#endif
        { "html", 0, NULL, 203 },@/
        { "permute", 0, NULL, 'p' },@/
        { "seed", 1, NULL, 's' },@/
        { "step", 1, NULL, 205 },@/
        { "target", 1, NULL, 't' },@/
        { "template", 1, NULL, 204 },@/
        { "help", 0, NULL, 'u' },@/
        { "verbose", 0, NULL, 'v' },@/
        { "version", 0, NULL, 201 },@/
        { 0, 0, 0, 0 }@/
    };
    int option_index = 0;

    while ((opt = getopt_long(argc, argv, "b:d:ps:t:uv", long_options, &option_index)) != -1) {

        switch (opt) {
            case 206:               //  \.{--all}  Generate all anagrams in CGI step 2
                cgi_all = true;
                break;

            case 208:               // \.{--bail}  Bail out after first match for word
                bail = true;
                break;

            case 'b':               // \.{-b}, \.{--bindict}  {\it binaryDictionary}
                bdictfile = optarg;
                break;

            case 202:               // \.{--cgi}  Set options from \.{uncgi} environment variables
                @<Set options from uncgi environment variables@>;
                break;

            case 200:               // \.{--copyright}  Print copyright information
                cout << "This program is in the public domain.\n";
                return 0;

            case 'd':               // \.{-d}, \.{--dictionary}  {\it dictionary-file}
                dictfile = optarg;
                break;

            case 207:               // \.{--export}  {\it dictionary-file}
                exportfile = optarg;
                break;

#ifdef NEEDED
            case 212:               // \.{--flatten-iso}  Flatten ISO 8859-1 8-bit codes to ASCII
                flattenISOchars = true;
                break;
#endif

            case 203:               // \.{--html}  Generate HTML output
                html = true;
                break;

            case 'p':               // \.{-p}, \.{--permute}  Generate permutations of target
                permute = true;
                break;

            case 's':               // \.{-s}, \.{--seed}  {\it seed-word}
                {
                    dictionaryWord *given = new dictionaryWord(optarg);
                    seed = seed + *given;
                    anagram.push_back(given);
                }
                break;

            case 205:               // {--step}  {\it step-number}
                cgi_step = atoi(optarg);
                break;

            case 't':               // \.{-t}, \.{--target}  {\it target-phrase}
                target = optarg;
                break;

            case 204:               // \.{--template}  {\it HTML-template-file}
                HTML_template = optarg;
                break;

            case 'u':               // \.{-u}, \.{--help}  Print how-to-call information
            case '?':
                usage();
                return 0;

            case 'v':               // \.{-v}, \.{--verbose}  Print processing information
                verbose = true;
                break;

            case 201:               // \.{--version}  Print version information
@q The ugly line breaks in the next two statements are to trick @>
@q CTANGLE into not concatenating the string literals and the @>
@q macro references without spaces, which causes a warning message @>
@q with GCC 7.4.0. @>
                cout << PRODUCT @,
                        " " @,
                        VERSION @,
                        "\n";
                cout << "Last revised: " @,
                        REVDATE  @,
                        "\n";
                cout << "The latest version is always available\n";
                cout << "at http://www.fourmilab.ch/anagram/\n";
                cout << "Please report bugs to bugs@@fourmilab.ch\n";
                return 0;

            default:
                cerr << "***Internal error: unhandled case " << opt << " in option processing.\n";
                return 1;
        }
    }

@
When we're invoked as a CGI program by a Web browser, the \.{uncgi}
program parses the \.{GET} or \.{POST} form arguments from the
invoking page and sets environment variables for each field in
the form.  When the \.{--cgi} option is specified on the command
line, this code checks for those variables and sets the corresponding
options.  This avoids the need for a clumsy and inefficient shell
script to translate the environment variables into command line
options.

@<Set options from uncgi environment variables@>=
    {
        char *env;

        uncgi();

        if ((env = getenv("WWW_target")) != NULL) {
            target = env;
        }

        if ((env = getenv("WWW_step")) != NULL) {
            cgi_step = atoi(env);
        } else {
            cgi_step = 1;
        }

        if (getenv("WWW_all") != NULL) {
            cgi_all = true;
        }

        if ((env = getenv("WWW_firstwords")) != NULL) {
            bool done = false;
            char *endw;

            while (!done) {
                if ((endw = strchr(env, ',')) != NULL) {
                    *endw = 0;
                    firstwords.push_back(env);
                    env = endw + 1;
                } else {
                    firstwords.push_back(env);
                    done = true;
                }
            }
        }

        if ((env = getenv("WWW_anagrams")) != NULL) {
            bool done = false;
            char *endw;

            while (!done) {
                if ((endw = strchr(env, ',')) != NULL) {
                    *endw = 0;
                    anagrams_for_word.push_back(env);
                    env = endw + 1;
                } else {
                    anagrams_for_word.push_back(env);
                    done = true;
                }
            }
        }

        if ((env = getenv("WWW_results")) != NULL) {
            bool done = false;
            char *endw;

            while (!done) {
                if ((endw = strchr(env, ' ')) != NULL) {
                    *endw = 0;
                    permutations.push_back(env);
                    env = endw + 1;
                } else {
                    permutations.push_back(env);
                    done = true;
                }
            }
        }

        if ((env = getenv("WWW_word")) != NULL) {
            if (!cgi_all) {
                dictionaryWord *given = new dictionaryWord(env);
                seed = seed + *given;
                anagram.push_back(given);
            }
        }

    }

@
Some more global variables to keep track of file name arguments on
the command line$\ldots$.

@<Global variables@>=
static string infile = "-",         // "-" means standard input or output
              outfile = "-";

@

@<Verify command-line arguments@>=
    if ((exportfile == "") && (target == "") && (optind >= argc)) {
        cerr << "No target phrase specified." << endl <<
                "Specify the --help option for how-to-call information." << endl;
        return 2;
    }

@** Character set definitions and translation tables.

The following sections define the character set used in the
program and provide translation tables among various representations
used in formats we emit.

@*1 ISO 8859-1 special characters.

We use the following definitions where ISO 8859-1 characters are required
as strings in the program.  Most modern compilers have no difficulty with
such characters embedded in string literals, but it's surprisingly
difficult to arrange for Plain \TeX\ (as opposed to \LaTeX) to
render them correctly.  Since CWEB produces Plain \TeX, the path of
least resistance is to use escapes for these characters, which
also guarantess the generated documentation will work on even the
most basic \TeX\ installation.  Characters are given their Unicode
names with spaces and hyphens replaced by underscores.  Character
defined with single quotes as |char| have named beginning with
|C_|.

@d REGISTERED_SIGN                              "\xAE"
@d C_LEFT_POINTING_DOUBLE_ANGLE_QUOTATION_MARK  0xAB
@d C_RIGHT_POINTING_DOUBLE_ANGLE_QUOTATION_MARK 0xBB
@d RIGHT_POINTING_DOUBLE_ANGLE_QUOTATION_MARK   "\xBB"


@*1 Flat 7-bit ASCII approximation of ISO characters.

The following table is indexed by ISO codes 160 to 255,
(|0xA0|--|0xFF|) and gives the flat ASCII rendering of
each ISO character.  For accented characters, these are
simply the characters with the accents removed; for more
esoteric characters the translations may be rather
eccentric.

@<Global variables@>=
                      /* Latin 1/Unicode Hex   Description */
static const char *const flattenISO[] = {
    " ",                              /* |0xA0| Non-breaking space */
    "!",                              /* |0xA1| Spanish open exclamation */
    "cents",                          /* |0xA2| Cent sign */
    "GBP",                            /* |0xA3| Pounds Sterling */
    "$",                              /* |0xA4| Universal currency symbol */
    "JPY",                            /* |0xA5| Japanese Yen */
    "|",                              /* |0xA6| Broken vertical bar */
    "Sec.",                           /* |0xA7| Section sign */
    "''",                             /* |0xA8| diaeresis */
    "(C)",                            /* |0xA9| Copyright */
    "a",                              /* |0xAA| Spanish feminine ordinal indicator */
    "<<",                             /* |0xAB| Left pointing guillemet */
    "NOT",                            /* |0xAC| Logical not */
    "",                               /* |0xAD| Soft (discretionary) hyphen */
    "(R)",                            /* |0xAE| Registered trademark */
    "-",                              /* |0xAF| Overbar */
    "o",                              /* |0xB0| Degree sign */
    "+/-",                            /* |0xB1| Plus or minus */
    "^2",                             /* |0xB2| Superscript 2 */
    "^3",                             /* |0xB3| Superscript 3 */
    "'",                              /* |0xB4| Acute accent */
    "mu",                             /* |0xB5| Micro sign */
    "PP.",                            /* |0xB6| Paragraph sign */
    ".",                              /* |0xB7| Middle dot */
    ",",                              /* |0xB8| Spacing cedilla */
    "^1",                             /* |0xB9| Superscript 1 */
    "o",                              /* |0xBA| Spanish masculine ordinal indicator */
    ">>",                             /* |0xBB| Right pointing guillemet */
    "1/4",                            /* |0xBC| Fraction one quarter */
    "1/2",                            /* |0xBD| Fraction one half */
    "3/4",                            /* |0xBE| Fraction three quarters */
    "?",                              /* |0xBF| Spanish open question */
    "A",                              /* |0xC0| Accented capital A grave */
    "A",                              /* |0xC1|                    acute */
    "A",                              /* |0xC2|                    circumflex */
    "A",                              /* |0xC3|                    tilde */
    "A",                              /* |0xC4|                    diaeresis */
    "A",                              /* |0xC5| Capital A ring / Angstrom symbol */
    "Ae",                             /* |0xC6| Capital Ae */
    "C",                              /* |0xC7| Capital C cedilla */
    "E",                              /* |0xC8| Accented capital E grave */
    "E",                              /* |0xC9|                    acute */
    "E",                              /* |0xCA|                    circumflex */
    "E",                              /* |0xCB|                    diaeresis */
    "I",                              /* |0xCC| Accented capital I grave */
    "I",                              /* |0xCD|                    acute */
    "I",                              /* |0xCE|                    circumflex */
    "I",                              /* |0xCF|                    diaeresis */
    "Th",                             /* |0xD0| Capital Eth */
    "N",                              /* |0xD1| Capital N tilde */
    "O",                              /* |0xD2| Accented capital O grave */
    "O",                              /* |0xD3|                    acute */
    "O",                              /* |0xD4|                    circumflex */
    "O",                              /* |0xD5|                    tilde */
    "O",                              /* |0xD6|                    diaeresis */
    "x",                              /* |0xD7| Multiplication sign */
    "O",                              /* |0xD8| Capital O slash */
    "U",                              /* |0xD9| Accented capital U grave */
    "U",                              /* |0xDA|                    acute */
    "U",                              /* |0xDB|                    circumflex */
    "U",                              /* |0xDC|                    diaeresis */
    "Y",                              /* |0xDD| Capital Y acute */
    "Th",                             /* |0xDE| Capital thorn */
    "ss",                             /* |0xDF| German small sharp s */
    "a",                              /* |0xE0| Accented small a grave */
    "a",                              /* |0xE1|                  acute */
    "a",                              /* |0xE2|                  circumflex */
    "a",                              /* |0xE3|                  tilde */
    "a",                              /* |0xE4|                  diaeresis */
    "a",                              /* |0xE5| Small a ring */
    "ae",                             /* |0xE6| Small ae */
    "c",                              /* |0xE7| Small c cedilla */
    "e",                              /* |0xE8| Accented small e grave */
    "e",                              /* |0xE9|                  acute */
    "e",                              /* |0xEA|                  circumflex */
    "e",                              /* |0xEB|                  diaeresis */
    "i",                              /* |0xEC| Accented small i grave */
    "i",                              /* |0xED|                  acute */
    "i",                              /* |0xEE|                  circumflex */
    "i",                              /* |0xEF|                  diaeresis */
    "th",                             /* |0xF0| Small eth */
    "n",                              /* |0xF1| Small n tilde */
    "o",                              /* |0xF2| Accented small o grave */
    "o",                              /* |0xF3|                  acute */
    "o",                              /* |0xF4|                  circumflex */
    "o",                              /* |0xF5|                  tilde */
    "o",                              /* |0xF6|                  diaeresis */
    "/",                              /* |0xF7| Division sign */
    "o",                              /* |0xF8| Small o slash */
    "u",                              /* |0xF9| Accented small u grave */
    "u",                              /* |0xFA|                  acute */
    "u",                              /* |0xFB|                  circumflex */
    "u",                              /* |0xFC|                  diaeresis */
    "y",                              /* |0xFD| Small y acute */
    "th",                             /* |0xFE| Small thorn */
    "y"                               /* |0xFF| Small y diaeresis */
};


@*1 ISO 8859-1 character types.

The following definitions provide equivalents for \.{ctype.h} macros
which work for ISO-8859 8 bit characters.  They require that
\.{ctype.h} be included before they're used.

@<Global variables@>=

#define isISOspace(x)   (isascii(((unsigned char) (x))) && \
                         isspace(((unsigned char) (x))))
#define isISOalpha(x)   ((isoalpha[(((unsigned char) (x))) / 8] & \
                         (0x80 >> ((((unsigned char) (x))) % 8))) != 0)
#define isISOupper(x)   ((isoupper[(((unsigned char) (x))) / 8] & \
                         (0x80 >> ((((unsigned char) (x))) % 8))) != 0)
#define isISOlower(x)   ((isolower[(((unsigned char) (x))) / 8] & \
                         (0x80 >> ((((unsigned char) (x))) % 8))) != 0)
#define toISOupper(x)   (isISOlower(x) ? (isascii(((unsigned char) (x))) ?  \
                            toupper(x) : (((((unsigned char) (x)) != 0xDF) && \
                            (((unsigned char) (x)) != 0xFF)) ? \
                            (((unsigned char) (x)) - 0x20) : (x))) : (x))
#define toISOlower(x)   (isISOupper(x) ? (isascii(((unsigned char) (x))) ?  \
                            tolower(x) : (((unsigned char) (x)) + 0x20)) \
                            : (x))

@
The following tables are bit vectors which define membership in the character
classes tested for by the preceding macros.

@<Global variables@>=
unsigned char isoalpha[32] = {
    0,0,0,0,0,0,0,0,127,255,255,224,127,255,255,224,0,0,0,0,0,0,0,0,255,255,
    254,255,255,255,254,255
};

unsigned char isoupper[32] = {
    0,0,0,0,0,0,0,0,127,255,255,224,0,0,0,0,0,0,0,0,0,0,0,0,255,255,254,254,
    0,0,0,0
};

unsigned char isolower[32] = {
    0,0,0,0,0,0,0,0,0,0,0,0,127,255,255,224,0,0,0,0,0,0,0,0,0,0,0,1,255,255,
    254,255
};

@*1 Character category table.

The character category table allows us to quickly count the number of
character by category (alphabetic, upper or lower case, digit, etc.)
while scanning a string.  Instead of a large number of procedural tests
in the inner loop, we use the |build_letter_category| function to
initialise a 256 element table of pointers to counters in which the
category counts are kept.  The table is simply indexed by each character
in the string and the indicated category count incremented.

@d G_clear() G_lower = G_upper = G_digits = G_spaces =
    G_punctuation = G_ISOlower = G_ISOupper =
    G_ISOpunctuation = G_other = 0

@<Global variables@>=
unsigned int *letter_category[256];

static unsigned int G_lower, G_upper, G_digits, G_spaces,
    G_punctuation, G_ISOlower, G_ISOupper, G_ISOpunctuation, G_other;

@
@<Character category table initialisation@>=
static void build_letter_category(void) {
    for (int c = 0; c < 256; c++) {
        if (isalpha(c)) {
            if (islower(c)) {
                 letter_category[c] = &G_lower;
             } else {
                 letter_category[c] = &G_upper;
             }
         } else {
            if (isdigit(c)) {
                letter_category[c] = &G_digits;
            } else if (isspace(c) || (c == '\xA0')) {  // ISO nonbreaking space is counted as space
                letter_category[c] = &G_spaces;
            } else if (ispunct(c)) {
                letter_category[c] = &G_punctuation;
            } else if (isISOalpha(c)) {
               if (isISOlower(c)) {
                   letter_category[c] = &G_ISOlower;
               } else {
                   letter_category[c] = &G_ISOupper;
               }
            } else if (c >= 0xA0) {
                letter_category[c] = &G_ISOpunctuation;
            } else {
                letter_category[c] = &G_other;
            }
        }
    }
}

@q  Release History and Development Log  @>

@i log.w

@** Index.
The following is a cross-reference table for \.{anagram}.
Single-character identifiers are not indexed, nor are
reserved words.  Underlined entries indicate where
an identifier was declared.
