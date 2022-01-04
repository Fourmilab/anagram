/*5:*/
#line 247 "anagram.w"


#define PRODUCT "anagram"
#define VERSION "1.5"
#define REVDATE "2019-08-08" \

#define dictionaryWordComparisonOperator(op)  \
bool dictionaryWord::operator op(dictionaryWord&w) { \
for(unsigned int i= 0;i<sizeof letterCount;i++) { \
if(!(letterCount[i]op w.letterCount[i]) ) { \
return false; \
} \
} \
return true; \
} \

#define REGISTERED_SIGN "\xAE"
#define C_LEFT_POINTING_DOUBLE_ANGLE_QUOTATION_MARK 0xAB
#define C_RIGHT_POINTING_DOUBLE_ANGLE_QUOTATION_MARK 0xBB
#define RIGHT_POINTING_DOUBLE_ANGLE_QUOTATION_MARK "\xBB" \
 \

#define G_clear() G_lower= G_upper= G_digits= G_spaces=  \
G_punctuation= G_ISOlower= G_ISOupper=  \
G_ISOpunctuation= G_other= 0 \


#line 249 "anagram.w"


/*52:*/
#line 1594 "anagram.w"

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

#include "getopt.h"     

extern"C"{
void uncgi(void);
}

/*:52*/
#line 251 "anagram.w"

/*6:*/
#line 258 "anagram.w"

/*35:*/
#line 1187 "anagram.w"

unsigned char**auxdict= NULL;
unsigned int auxdictl= 0;

/*:35*//*37:*/
#line 1271 "anagram.w"

vector<string> anagrams;
vector<string> firstwords;
vector<string> anagrams_for_word;
vector<string> permutations;

/*:37*//*54:*/
#line 1663 "anagram.w"

static bool verbose= false;

/*:54*//*58:*/
#line 1925 "anagram.w"

static string infile= "-",
outfile= "-";

/*:58*//*62:*/
#line 1973 "anagram.w"


static const char*const flattenISO[]= {
" ",
"!",
"cents",
"GBP",
"$",
"JPY",
"|",
"Sec.",
"''",
"(C)",
"a",
"<<",
"NOT",
"",
"(R)",
"-",
"o",
"+/-",
"^2",
"^3",
"'",
"mu",
"PP.",
".",
",",
"^1",
"o",
">>",
"1/4",
"1/2",
"3/4",
"?",
"A",
"A",
"A",
"A",
"A",
"A",
"Ae",
"C",
"E",
"E",
"E",
"E",
"I",
"I",
"I",
"I",
"Th",
"N",
"O",
"O",
"O",
"O",
"O",
"x",
"O",
"U",
"U",
"U",
"U",
"Y",
"Th",
"ss",
"a",
"a",
"a",
"a",
"a",
"a",
"ae",
"c",
"e",
"e",
"e",
"e",
"i",
"i",
"i",
"i",
"th",
"n",
"o",
"o",
"o",
"o",
"o",
"/",
"o",
"u",
"u",
"u",
"u",
"y",
"th",
"y"
};


/*:62*//*63:*/
#line 2081 "anagram.w"


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

/*:63*//*64:*/
#line 2103 "anagram.w"

unsigned char isoalpha[32]= {
0,0,0,0,0,0,0,0,127,255,255,224,127,255,255,224,0,0,0,0,0,0,0,0,255,255,
254,255,255,255,254,255
};

unsigned char isoupper[32]= {
0,0,0,0,0,0,0,0,127,255,255,224,0,0,0,0,0,0,0,0,0,0,0,0,255,255,254,254,
0,0,0,0
};

unsigned char isolower[32]= {
0,0,0,0,0,0,0,0,0,0,0,0,127,255,255,224,0,0,0,0,0,0,0,0,0,0,0,1,255,255,
254,255
};

/*:64*//*65:*/
#line 2133 "anagram.w"

unsigned int*letter_category[256];

static unsigned int G_lower,G_upper,G_digits,G_spaces,
G_punctuation,G_ISOlower,G_ISOupper,G_ISOpunctuation,G_other;

/*:65*/
#line 259 "anagram.w"

/*7:*/
#line 276 "anagram.w"

class dictionaryWord{
public:
string text;
unsigned char letterCount[26];





unsigned int upper,
lower,
digits,
spaces,
punctuation,
ISOupper,
ISOlower,
ISOpunctuation;

dictionaryWord(string s= ""){
set(s);
}

dictionaryWord(int i){
text= "";
memset(letterCount,0,sizeof letterCount);
upper= lower= digits= spaces= punctuation= ISOupper= 
ISOlower= ISOpunctuation= 0;
}

void set(string s= ""){
text= s;
update();
}

string get(void){
return text;
}

unsigned int length(void)const{
return text.length();
}

void noBlanks(void){
string::iterator ep= remove_if(text.begin(),text.end(),&dictionaryWord::is_iso_space);
text.resize(ep-text.begin());
update();
}

void onlyLetters(void){
string::iterator ep= remove_if(text.begin(),text.end(),&dictionaryWord::is_non_iso_letter);
text.resize(ep-text.begin());
update();
}

void toLower(void){
transform(text.begin(),text.end(),text.begin(),&dictionaryWord::to_iso_lower);
update();
}

void toUpper(void){
transform(text.begin(),text.end(),text.begin(),&dictionaryWord::to_iso_upper);
update();
}

void ISOtoASCII(void);

void describe(ostream&os= cout);

bool operator<=(dictionaryWord&w);
bool operator> (dictionaryWord&w);
bool operator>=(dictionaryWord&w);
bool operator<(dictionaryWord&w);
bool operator==(dictionaryWord&w);
bool operator!=(dictionaryWord&w);

bool contained(const dictionaryWord*wbase,const dictionaryWord*candidate);
bool contained(const dictionaryWord*wbase,unsigned char*candidate);

dictionaryWord operator+(dictionaryWord&w);
dictionaryWord operator-(dictionaryWord&w);

dictionaryWord operator+= (dictionaryWord&w);

void exportToBinaryFile(ostream&os);

protected:
void countLetters(void);

void update(void){
memset(letterCount,0,sizeof letterCount);
upper= lower= digits= spaces= punctuation= ISOupper= 
ISOlower= ISOpunctuation= 0;
countLetters();
}

/*16:*/
#line 622 "anagram.w"

static bool is_iso_space(char c){
return isspace(c)||(c=='\xA0');
}

static bool is_non_iso_letter(char c){
return!isISOalpha(c);
}

static char to_iso_lower(char c){
return toISOlower(c);
}

static char to_iso_upper(char c){
return toISOupper(c);
}

/*:16*/
#line 372 "anagram.w"
;
};

/*:7*//*18:*/
#line 654 "anagram.w"

class dlencomp{
public:
int operator()(const dictionaryWord&a,const dictionaryWord&b)const{
return a.length()> b.length();
}
};

/*:18*//*19:*/
#line 666 "anagram.w"

class dictionary:public vector<dictionaryWord> {
public:
void loadFromFile(istream&is,bool punctuationOK= true,
bool digitsOK= true){
string s;

while(getline(is,s)){
dictionaryWord w(s);
if((punctuationOK||
((w.punctuation==0)&&
(w.spaces==0)&&
(w.ISOpunctuation==0)))&&
(digitsOK||(w.digits==0))
){
push_back(dictionaryWord(s));
}
}

if(verbose){
cerr<<"Loaded "<<size()<<" words from word list."<<endl;
}
}

void describe(ostream&os= cout){
vector<dictionaryWord> ::iterator p;
for(p= begin();p!=end();p++){
cout<<p->text<<endl;
}
}

void sortByDescendingLength(void){
stable_sort(begin(),end(),dlencomp());
}

void exportToBinaryFile(ostream&os);
};

/*:19*//*21:*/
#line 750 "anagram.w"

class binaryDictionary{
public:
long flen;
unsigned char*dict;
int fileHandle;
unsigned long nwords;

static const unsigned int letterCountSize= 26,
categoryCountSize= 8;

void loadFromFile(string s){
/*22:*/
#line 853 "anagram.w"

FILE*fp;

fp= fopen(s.c_str(),"rb");
if(fp==NULL){
cout<<"Cannot open binary dictionary file "<<s<<endl;
exit(1);
}
fseek(fp,0,2);
flen= ftell(fp);
#ifndef HAVE_MMAP
dict= new unsigned char[flen];
rewind(fp);
fread(dict,flen,1,fp);
#endif
fclose(fp);
#ifdef HAVE_MMAP
fileHandle= open(s.c_str(),O_RDONLY);
dict= reinterpret_cast<unsigned char*> (mmap((caddr_t)0,flen,
PROT_READ,MAP_SHARED|MAP_NORESERVE,
fileHandle,0));
#endif
nwords= (((((dict[0]<<8)|dict[1])<<8)|dict[2])<<8)|dict[3];
if(verbose){
cerr<<"Loaded "<<nwords<<" words from binary dictionary "<<s<<"."<<endl;
}


/*:22*/
#line 762 "anagram.w"
;
}

binaryDictionary(){
fileHandle= -1;
dict= NULL;
}

~binaryDictionary(){
#ifdef HAVE_MMAP
if(fileHandle!=-1){
munmap(reinterpret_cast<char*> (dict),flen);
close(fileHandle);
}
#else
if(dict!=NULL){
delete dict;
}
#endif
}

void describe(ostream&os= cout){
}

static unsigned int itemSize(unsigned char*p){
return p[0]+1+letterCountSize+categoryCountSize;
}

unsigned char*first(void){
return dict+4;
}

static unsigned char*next(unsigned char*p){
p+= itemSize(p);
return(*p==0)?NULL:p;
}

static unsigned char*letterCount(unsigned char*p){

return p+p[0]+1;
}

static unsigned char*characterCategories(unsigned char*p){

return letterCount(p)+letterCountSize;
}

static unsigned int length(unsigned char*p){
return p[0];
}

static void getText(unsigned char*p,string*s){
s->assign(reinterpret_cast<char*> (p+1),p[0]);
}

static void setDictionaryWordCheap(dictionaryWord*w,unsigned char*p){
getText(p,&(w->text));
memcpy(w->letterCount,letterCount(p),letterCountSize);
}



static const unsigned int C_upper= 0,C_lower= 1,C_digits= 2,
C_spaces= 3,C_punctuation= 4,C_ISOupper= 5,
C_ISOlower= 6,C_ISOpunctuation= 7;

static void printItem(unsigned char*p,ostream&os= cout);

void printDictionary(ostream&os= cout);
};

/*:21*/
#line 260 "anagram.w"

/*53:*/
#line 1638 "anagram.w"

#ifdef NEEDED
static bool flattenISOchars= false;
#endif
static bool bail= false;
static string dictfile= "crossword.txt";
static string bdictfile= "wordlist.bin";
static string exportfile= "";
static string target= "";
static dictionaryWord seed("");
static dictionaryWord empty("");
static vector<dictionaryWord*> anagram;
static int cgi_step= 0;
static bool cgi_all= false;
static bool html= false;
static string HTML_template= "template.html";
static bool direct_output= false;
static ostream&dout= cout;
static bool permute= false;

/*:53*/
#line 261 "anagram.w"

/*8:*/
#line 379 "anagram.w"

void dictionaryWord::countLetters(void){
const unsigned char*cp= (unsigned char*)text.c_str();
unsigned int c;

G_clear();

while((c= *cp++)!=0){
if(c>='A'&&c<='Z'){
letterCount[c-'A']++;
}else if(c>='a'&&c<='z'){
letterCount[c-'a']++;
}
(*(letter_category[c]))++;
#ifdef ISO_NEEDED
if(c>=0xA0){
const char*flat= flattenISO[((unsigned char)c)-0xA0];
while((c= *flat++)!=0){
if(islower(c)){
c= toupper(c);
}
letterCount[c-'A']++;
}
}
#endif
}

lower= G_lower;
upper= G_upper;
digits= G_digits;
spaces= G_spaces;
punctuation= G_punctuation;
ISOlower= G_ISOlower;
ISOupper= G_ISOupper;
ISOpunctuation= G_ISOpunctuation;
}

/*:8*//*9:*/
#line 423 "anagram.w"

void dictionaryWord::ISOtoASCII(void){
for(string::iterator p= text.begin();p!=text.end();p++){
if(((unsigned char)*p)>=0xA0){
int n= p-text.begin();
unsigned int c= ((unsigned char)*p)-0xA0;
text.replace(p,p+1,flattenISO[c]);
p= text.begin()+n+(strlen(flattenISO[c])-1);
}
}
}

/*:9*//*10:*/
#line 440 "anagram.w"

void dictionaryWord::describe(ostream&os){
os<<text<<endl;
os<<"  Total length: "<<length()<<" characters."<<endl;
for(unsigned int i= 0;i<(sizeof letterCount);i++){
if(letterCount[i]> 0){
cout<<"  "<<static_cast<char> (i+'a')<<"  "<<
setw(2)<<static_cast<int> (letterCount[i])<<endl;
}
}
os<<"  ASCII: Letters: "<<(upper+lower)<<"  (Upper: "<<
upper<<"  Lower: "<<lower<<").  Digits: "<<
digits<<"  Punctuation: "<<punctuation<<
"  Blanks: "<<spaces<<endl;
os<<"  ISO: Letters: "<<(ISOupper+ISOlower)<<"  (Upper: "<<
ISOupper<<"  Lower: "<<ISOlower<<").  Punctuation: "<<
ISOpunctuation<<endl;
}

/*:10*//*11:*/
#line 468 "anagram.w"

void dictionaryWord::exportToBinaryFile(ostream&os){
unsigned char c;

#define outCount(x) c =  (x); os.put(c)

outCount(text.length());
os.write(text.data(),text.length());

for(unsigned int i= 0;i<sizeof letterCount;i++){
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

/*:11*//*12:*/
#line 518 "anagram.w"

dictionaryWordComparisonOperator(<);
dictionaryWordComparisonOperator(> );
dictionaryWordComparisonOperator(==);
dictionaryWordComparisonOperator(!=);
dictionaryWordComparisonOperator(<=);
dictionaryWordComparisonOperator(>=);
/*:12*//*13:*/
#line 533 "anagram.w"

dictionaryWord dictionaryWord::operator+(dictionaryWord&w){
dictionaryWord result(text+w.text);
return result;
}

dictionaryWord dictionaryWord::operator+= (dictionaryWord&w){
text+= w.text;
for(unsigned int i= 0;i<sizeof letterCount;i++){
letterCount[i]+= w.letterCount[i];
}
lower+= w.lower;
upper+= w.upper;
digits+= w.digits;
spaces+= w.spaces;
punctuation+= w.punctuation;
ISOlower+= w.ISOlower;
ISOupper+= w.ISOupper;
ISOpunctuation+= w.ISOpunctuation;
return*this;
}

dictionaryWord dictionaryWord::operator-(dictionaryWord&w){
dictionaryWord result= *this;

for(string::iterator p= w.text.begin();p!=w.text.end();p++){
string::size_type n= result.text.find(*p);
if(n!=string::npos){
result.text.erase(n,1);
}
}
return result;
}

/*:13*//*14:*/
#line 583 "anagram.w"

bool dictionaryWord::contained(const dictionaryWord*wbase,
const dictionaryWord*candidate){
for(unsigned int i= 0;i<sizeof letterCount;i++){
if((wbase->letterCount[i]+candidate->letterCount[i])> 
letterCount[i]){
return false;
}
}
return true;
}


/*:14*//*15:*/
#line 603 "anagram.w"

bool dictionaryWord::contained(const dictionaryWord*wbase,
unsigned char*candidate){
unsigned char*lc= binaryDictionary::letterCount(candidate);

for(unsigned int i= 0;i<sizeof letterCount;i++){
if((wbase->letterCount[i]+lc[i])> 
letterCount[i]){
return false;
}
}
return true;
}

/*:15*//*20:*/
#line 714 "anagram.w"

void dictionary::exportToBinaryFile(ostream&os){
unsigned long nwords= size();

os.put(nwords>>24);
os.put((nwords>>16)&0xFF);
os.put((nwords>>8)&0xFF);
os.put(nwords&0xFF);

vector<dictionaryWord> ::iterator p;

for(p= begin();p!=end();p++){
p->exportToBinaryFile(os);
}
os.put(0);
if(verbose){
cerr<<"Exported "<<nwords<<" to "<<
os.tellp()<<" byte binary dictionary."<<endl;
}
}


/*:20*//*23:*/
#line 885 "anagram.w"

void binaryDictionary::printItem(unsigned char*p,ostream&os){
unsigned int textLen= *p++;
string text(reinterpret_cast<char*> (p),textLen);

os<<text<<endl;
p+= textLen;

for(unsigned int i= 0;i<letterCountSize;i++){
unsigned int n= *p++;
if(n> 0){
os<<"  "<<static_cast<char> ('a'+i)<<"  "<<setw(2)<<n<<endl;
}
}

unsigned int upper,lower,digits,spaces,punctuation,
ISOupper,ISOlower,ISOpunctuation;

upper= *p++;
lower= *p++;
digits= *p++;
spaces= *p++;
punctuation= *p++;
ISOupper= *p++;
ISOlower= *p++;
ISOpunctuation= *p;

os<<"  ASCII: Letters: "<<(upper+lower)<<"  (Upper: "<<
upper<<"  Lower: "<<lower<<").  Digits: "<<
digits<<"  Punctuation: "<<punctuation<<
"  Blanks: "<<spaces<<endl;
os<<"  ISO: Letters: "<<(ISOupper+ISOlower)<<"  (Upper: "<<
ISOupper<<"  Lower: "<<ISOlower<<").  Punctuation: "<<
ISOpunctuation<<endl;

}

/*:23*//*24:*/
#line 926 "anagram.w"

void binaryDictionary::printDictionary(ostream&os){
unsigned char*p= first();

while(p!=NULL){
printItem(p,os);
p= next(p);
}
}


/*:24*/
#line 262 "anagram.w"

/*34:*/
#line 1172 "anagram.w"

/*66:*/
#line 2140 "anagram.w"

static void build_letter_category(void){
for(int c= 0;c<256;c++){
if(isalpha(c)){
if(islower(c)){
letter_category[c]= &G_lower;
}else{
letter_category[c]= &G_upper;
}
}else{
if(isdigit(c)){
letter_category[c]= &G_digits;
}else if(isspace(c)||(c=='\xA0')){
letter_category[c]= &G_spaces;
}else if(ispunct(c)){
letter_category[c]= &G_punctuation;
}else if(isISOalpha(c)){
if(isISOlower(c)){
letter_category[c]= &G_ISOlower;
}else{
letter_category[c]= &G_ISOupper;
}
}else if(c>=0xA0){
letter_category[c]= &G_ISOpunctuation;
}else{
letter_category[c]= &G_other;
}
}
}
}



#line 1 "log.w"

/*:66*/
#line 1173 "anagram.w"
;
/*36:*/
#line 1206 "anagram.w"

static void build_auxiliary_dictionary(binaryDictionary*bd,dictionaryWord*target){
if(auxdict!=NULL){
delete auxdict;
auxdict= NULL;
auxdictl= 0;
}

unsigned long i;
unsigned char*p= bd->first();
unsigned int tlen= target->length();



for(i= 0;i<bd->nwords;i++){
if(binaryDictionary::length(p)<=tlen){
break;
}
p= binaryDictionary::next(p);
}



if(i<bd->nwords){
auxdict= new unsigned char*[bd->nwords-i];

for(;i<bd->nwords;i++){
unsigned char*lc= binaryDictionary::letterCount(p);

for(unsigned int j= 0;j<binaryDictionary::letterCountSize;j++){
if(lc[j]> target->letterCount[j]){
goto busted;
}
}
auxdict[auxdictl++]= p;
busted:;
p= binaryDictionary::next(p);
}
}
}

/*:36*/
#line 1174 "anagram.w"
;
/*38:*/
#line 1278 "anagram.w"

static bool anagram_search(dictionaryWord&target,vector<dictionaryWord*> &a,
unsigned int n,
bool bail= false,int prune= -1){

/*:38*//*39:*/
#line 1292 "anagram.w"

vector<dictionaryWord*> ::size_type i;
dictionaryWord wbase(0);

for(i= 0;i<a.size();i++){
wbase.text+= a[i]->text;
for(unsigned int j= 0;j<binaryDictionary::letterCountSize;j++){
wbase.letterCount[j]+= a[i]->letterCount[j];
}
}

/*:39*//*40:*/
#line 1309 "anagram.w"

if(memcmp(target.letterCount,wbase.letterCount,
binaryDictionary::letterCountSize)==0){
string result;
for(i= 0;i<a.size();i++){
if(i> 0){
result+= " ";
}
result+= a[i]->text;
if(static_cast<int> (i)==prune){
break;
}
}
if(direct_output){
dout<<result<<endl;
}else{
anagrams.push_back(result);
}
return true;
}

/*:40*//*41:*/
#line 1340 "anagram.w"

for(;n<auxdictl;n++){
unsigned char*p= auxdict[n];

if((wbase.length()+binaryDictionary::length(p))<=target.length()){
if(target.contained(&wbase,p)){
dictionaryWord aw;

binaryDictionary::setDictionaryWordCheap(&aw,p);
a.push_back(&aw);
bool success= anagram_search(target,a,n,bail,prune);
a.pop_back();
if(bail&&success){
return(a.size()> 1);
}
}
}
}

return false;
}

/*:41*/
#line 1175 "anagram.w"
;
/*42:*/
#line 1369 "anagram.w"

static void generateHTML(ostream&os,char stopAt= 0)
{
ifstream is(HTML_template.c_str());
string s;
bool skipping= false;

while(getline(is,s)){
if(s.substr(0,5)=="<!-- "){
/*43:*/
#line 1392 "anagram.w"

if(s[5]=='@'){
/*45:*/
#line 1419 "anagram.w"

if(!skipping){
switch(s[6]){
case'1':
os<<"    value=\""<<target<<"\""<<endl;
break;

case'2':
/*46:*/
#line 1456 "anagram.w"

{vector<string> &svec= (cgi_step==1)?anagrams:firstwords;

vector<string> ::size_type nfound= svec.size();
if(nfound> 12){
nfound= 12;
}
os<<"    size="<<nfound<<">"<<endl;
for(vector<string> ::iterator p= svec.begin();
p!=svec.end();p++){
os<<"    <option>"<<*p<<endl;
}
}

/*:46*/
#line 1427 "anagram.w"
;
break;

case'3':
/*47:*/
#line 1475 "anagram.w"

{vector<string> &svec= (cgi_step==1)?anagrams:firstwords;

os<<"<input type=\"hidden\" name=\"target\" value=\""<<target<<"\">"<<endl;
os<<"<input type=\"hidden\" name=\"firstwords\" value=\"";
for(vector<string> ::iterator p= svec.begin();
p!=svec.end();p++){
if(p!=svec.begin()){
os<<",";
}
os<<*p;
}
os<<"\">"<<endl;
}

/*:47*/
#line 1431 "anagram.w"
;
break;

case'4':
/*48:*/
#line 1496 "anagram.w"

{vector<string> &svec= (cgi_step==2)?anagrams:anagrams_for_word;

vector<string> ::size_type nfound= svec.size();
if(nfound> 12){
nfound= 12;
}
os<<"    size="<<nfound<<">"<<endl;
for(vector<string> ::iterator p= svec.begin();
p!=svec.end();p++){
os<<"    <option>"<<*p<<endl;
}
}

/*:48*/
#line 1435 "anagram.w"
;
break;

case'5':
/*51:*/
#line 1562 "anagram.w"

{
int n= permutations.size(),nbang= 1,cols= 1;
vector<string> ::iterator p;

while(n> 1){
nbang*= n--;
}
for(p= permutations.begin();p!=permutations.end();p++){
if(p!=permutations.begin()){
cols++;
}
cols+= p->length();
}
cout<<"cols="<<cols<<" rows="<<nbang<<">"<<endl;

sort(permutations.begin(),permutations.end());
do{
for(p= permutations.begin();p!=permutations.end();p++){
if(p!=permutations.begin()){
os<<" ";
}
os<<*p;
}
os<<endl;
}while(next_permutation(permutations.begin(),permutations.end()));
}

/*:51*/
#line 1439 "anagram.w"
;
break;

case'6':
/*49:*/
#line 1515 "anagram.w"

{
os<<"<input type=\"hidden\" name=\"target\" value=\""<<target<<"\">"<<endl;
os<<"<input type=\"hidden\" name=\"firstwords\" value=\"";
for(vector<string> ::iterator p= firstwords.begin();
p!=firstwords.end();p++){
if(p!=firstwords.begin()){
os<<",";
}
os<<*p;
}
os<<"\">"<<endl;
}

/*:49*/
#line 1443 "anagram.w"
;
/*50:*/
#line 1534 "anagram.w"

{vector<string> &svec= (cgi_step==2)?anagrams:anagrams_for_word;

os<<"<input type=\"hidden\" name=\"anagrams\" value=\"";
for(vector<string> ::iterator p= svec.begin();
p!=svec.end();p++){
if(p!=svec.begin()){
os<<",";
}
os<<*p;
}
os<<"\">"<<endl;
}

/*:50*/
#line 1444 "anagram.w"
;
break;
}
}

/*:45*/
#line 1394 "anagram.w"
;
}else{
/*44:*/
#line 1407 "anagram.w"

if(s[5]=='X'){
skipping= false;
}else if(s[5]==stopAt){
skipping= true;
}

/*:44*/
#line 1396 "anagram.w"
;
}

/*:43*/
#line 1378 "anagram.w"
;
}else{
if(!skipping){
os<<s<<endl;
}
}
}
}

/*:42*/
#line 1176 "anagram.w"
;

/*:34*//*55:*/
#line 1671 "anagram.w"

static void usage(void)
{
cout<<PRODUCT<<"  --  Anagram Finder.  Call\n";
cout<<"             with "<<PRODUCT<<" [options] 'phrase' [contained words]\n";
cout<<"\n";
cout<<"Options:\n";
cout<<"    --all                  Generate all anagrams in CGI step 2\n";
cout<<"    --bail                 Bail out after first match for a given word\n";
cout<<"    --bindict, -b file     Use file as binary dictionary\n";
cout<<"    --cgi                  Set options from uncgi environment variables\n";
cout<<"    --copyright            Print copyright information\n";
cout<<"    --dictionary, -d file  Use file as dictionary\n";
cout<<"    --export file          Export binary dictionary file\n";
#ifdef NEEDED
cout<<"    --flatten-iso          Flatten ISO 8859-1 8-bit codes to ASCII\n";
#endif
cout<<"    --help, -u             Print this message\n";
cout<<"    --html                 Generate HTML output\n";
cout<<"    --permute, -p          Generate permutations of target\n";
cout<<"    --seed, -s word        Specify seed word\n";
cout<<"    --step number          CGI processing step\n";
cout<<"    --target, -t phrase    Target phrase\n";
cout<<"    --template             Template for HTML output\n";
cout<<"    --verbose, -v          Print processing information\n";
cout<<"    --version              Print version number\n";
cout<<"\n";
cout<<"by John Walker\n";
cout<<"http://www.fourmilab.ch/\n";
}

/*:55*/
#line 263 "anagram.w"

/*25:*/
#line 943 "anagram.w"


int main(int argc,char*argv[])
{
int opt;

build_letter_category();

/*56:*/
#line 1710 "anagram.w"


static const struct option long_options[]= {
{"all",0,NULL,206},
{"bail",0,NULL,208},
{"bindict",1,NULL,'b'},
{"cgi",0,NULL,202},
{"copyright",0,NULL,200},
{"dictionary",1,NULL,'d'},
{"export",1,NULL,207},
#ifdef NEEDED
{"flatten-iso",0,NULL,212},
#endif
{"html",0,NULL,203},
{"permute",0,NULL,'p'},
{"seed",1,NULL,'s'},
{"step",1,NULL,205},
{"target",1,NULL,'t'},
{"template",1,NULL,204},
{"help",0,NULL,'u'},
{"verbose",0,NULL,'v'},
{"version",0,NULL,201},
{0,0,0,0}
};
int option_index= 0;

while((opt= getopt_long(argc,argv,"b:d:ps:t:uv",long_options,&option_index))!=-1){

switch(opt){
case 206:
cgi_all= true;
break;

case 208:
bail= true;
break;

case'b':
bdictfile= optarg;
break;

case 202:
/*57:*/
#line 1843 "anagram.w"

{
char*env;

uncgi();

if((env= getenv("WWW_target"))!=NULL){
target= env;
}

if((env= getenv("WWW_step"))!=NULL){
cgi_step= atoi(env);
}else{
cgi_step= 1;
}

if(getenv("WWW_all")!=NULL){
cgi_all= true;
}

if((env= getenv("WWW_firstwords"))!=NULL){
bool done= false;
char*endw;

while(!done){
if((endw= strchr(env,','))!=NULL){
*endw= 0;
firstwords.push_back(env);
env= endw+1;
}else{
firstwords.push_back(env);
done= true;
}
}
}

if((env= getenv("WWW_anagrams"))!=NULL){
bool done= false;
char*endw;

while(!done){
if((endw= strchr(env,','))!=NULL){
*endw= 0;
anagrams_for_word.push_back(env);
env= endw+1;
}else{
anagrams_for_word.push_back(env);
done= true;
}
}
}

if((env= getenv("WWW_results"))!=NULL){
bool done= false;
char*endw;

while(!done){
if((endw= strchr(env,' '))!=NULL){
*endw= 0;
permutations.push_back(env);
env= endw+1;
}else{
permutations.push_back(env);
done= true;
}
}
}

if((env= getenv("WWW_word"))!=NULL){
if(!cgi_all){
dictionaryWord*given= new dictionaryWord(env);
seed= seed+*given;
anagram.push_back(given);
}
}

}

/*:57*/
#line 1752 "anagram.w"
;
break;

case 200:
cout<<"This program is in the public domain.\n";
return 0;

case'd':
dictfile= optarg;
break;

case 207:
exportfile= optarg;
break;

#ifdef NEEDED
case 212:
flattenISOchars= true;
break;
#endif

case 203:
html= true;
break;

case'p':
permute= true;
break;

case's':
{
dictionaryWord*given= new dictionaryWord(optarg);
seed= seed+*given;
anagram.push_back(given);
}
break;

case 205:
cgi_step= atoi(optarg);
break;

case't':
target= optarg;
break;

case 204:
HTML_template= optarg;
break;

case'u':
case'?':
usage();
return 0;

case'v':
verbose= true;
break;

case 201:




cout<<PRODUCT
" "
VERSION
"\n";
cout<<"Last revised: "
REVDATE
"\n";
cout<<"The latest version is always available\n";
cout<<"at http://www.fourmilab.ch/anagram/\n";
cout<<"Please report bugs to bugs@fourmilab.ch\n";
return 0;

default:
cerr<<"***Internal error: unhandled case "<<opt<<" in option processing.\n";
return 1;
}
}

/*:56*/
#line 951 "anagram.w"
;
/*59:*/
#line 1931 "anagram.w"

if((exportfile=="")&&(target=="")&&(optind>=argc)){
cerr<<"No target phrase specified."<<endl<<
"Specify the --help option for how-to-call information."<<endl;
return 2;
}

/*:59*/
#line 952 "anagram.w"
;

/*26:*/
#line 972 "anagram.w"

if(exportfile!=""){
/*28:*/
#line 1035 "anagram.w"

dictionary dict;

ofstream os(exportfile.c_str(),ios::binary|ios::out);
ifstream dif(dictfile.c_str());
dict.loadFromFile(dif,false,false);
dict.sortByDescendingLength();

#ifdef DICTECHO
{
ofstream es("common.txt");
for(int i= 0;i<dict.size();i++){
es<<dict[i].text<<endl;
}
es.close();
}
#endif

dict.exportToBinaryFile(os);
os.close();
return 0;

/*:28*/
#line 974 "anagram.w"
;
}

dictionaryWord w(target);
w.onlyLetters();
w.toLower();

/*27:*/
#line 1019 "anagram.w"

binaryDictionary bdict;

if((cgi_step<3)&&(!permute)){
if(bdictfile!=""){
bdict.loadFromFile(bdictfile);
}
}

/*:27*/
#line 981 "anagram.w"
;

switch(cgi_step){
case 0:
{
direct_output= true;
/*29:*/
#line 1062 "anagram.w"

if((optind<argc)&&(target=="")){
target= argv[optind];
w.set(target);
w.onlyLetters();
w.toLower();
optind++;
}

/*:29*/
#line 987 "anagram.w"
;
if(permute){
/*31:*/
#line 1119 "anagram.w"

/*32:*/
#line 1128 "anagram.w"

bool done= false;
string::size_type pos= target.find_first_not_of(' '),spos;

while(!done){
if((spos= target.find_first_of(' ',pos))!=string::npos){
permutations.push_back(target.substr(pos,spos-pos));
pos= target.find_first_not_of(' ',spos+1);
}else{
if(pos<target.length()){
permutations.push_back(target.substr(pos));
}
done= true;
}
}

/*:32*/
#line 1120 "anagram.w"
;
/*33:*/
#line 1149 "anagram.w"

int n= permutations.size(),nbang= 1;
vector<string> ::iterator p;

while(n> 1){
nbang*= n--;
}

sort(permutations.begin(),permutations.end());
do{
for(p= permutations.begin();p!=permutations.end();p++){
if(p!=permutations.begin()){
dout<<" ";
}
dout<<*p;
}
dout<<endl;
}while(next_permutation(permutations.begin(),permutations.end()));

/*:33*/
#line 1121 "anagram.w"
;

/*:31*/
#line 989 "anagram.w"
;
}else{
/*30:*/
#line 1079 "anagram.w"

build_auxiliary_dictionary(&bdict,&w);

if(optind<argc){
for(int n= optind;n<argc;n++){
dictionaryWord*given= new dictionaryWord(argv[n]);
seed= seed+*given;
anagram.push_back(given);
}
if((seed<=w)&&(!(seed> w))){
anagram_search(w,anagram,0,bail,bail?0:-1);
}else{
cerr<<"Seed words are not contained in target."<<endl;
return 2;
}
}else if(seed.length()> 0){
if((seed<=w)&&(!(seed> w))){
anagram_search(w,anagram,0,bail,bail?0:-1);
}else{
cerr<<"Seed words are not contained in target."<<endl;
return 2;
}
}else{
for(unsigned int n= 0;n<auxdictl;n++){
unsigned char*p= auxdict[n];

vector<dictionaryWord*> anagram;
dictionaryWord aw;

binaryDictionary::setDictionaryWordCheap(&aw,p);
anagram.push_back(&aw);
anagram_search(w,anagram,n,bail,bail?0:-1);
}
}

/*:30*/
#line 991 "anagram.w"
;
}
}
break;

case 1:
bail= true;
/*30:*/
#line 1079 "anagram.w"

build_auxiliary_dictionary(&bdict,&w);

if(optind<argc){
for(int n= optind;n<argc;n++){
dictionaryWord*given= new dictionaryWord(argv[n]);
seed= seed+*given;
anagram.push_back(given);
}
if((seed<=w)&&(!(seed> w))){
anagram_search(w,anagram,0,bail,bail?0:-1);
}else{
cerr<<"Seed words are not contained in target."<<endl;
return 2;
}
}else if(seed.length()> 0){
if((seed<=w)&&(!(seed> w))){
anagram_search(w,anagram,0,bail,bail?0:-1);
}else{
cerr<<"Seed words are not contained in target."<<endl;
return 2;
}
}else{
for(unsigned int n= 0;n<auxdictl;n++){
unsigned char*p= auxdict[n];

vector<dictionaryWord*> anagram;
dictionaryWord aw;

binaryDictionary::setDictionaryWordCheap(&aw,p);
anagram.push_back(&aw);
anagram_search(w,anagram,n,bail,bail?0:-1);
}
}

/*:30*/
#line 998 "anagram.w"
;
generateHTML(cout,'2');
break;

case 2:
/*30:*/
#line 1079 "anagram.w"

build_auxiliary_dictionary(&bdict,&w);

if(optind<argc){
for(int n= optind;n<argc;n++){
dictionaryWord*given= new dictionaryWord(argv[n]);
seed= seed+*given;
anagram.push_back(given);
}
if((seed<=w)&&(!(seed> w))){
anagram_search(w,anagram,0,bail,bail?0:-1);
}else{
cerr<<"Seed words are not contained in target."<<endl;
return 2;
}
}else if(seed.length()> 0){
if((seed<=w)&&(!(seed> w))){
anagram_search(w,anagram,0,bail,bail?0:-1);
}else{
cerr<<"Seed words are not contained in target."<<endl;
return 2;
}
}else{
for(unsigned int n= 0;n<auxdictl;n++){
unsigned char*p= auxdict[n];

vector<dictionaryWord*> anagram;
dictionaryWord aw;

binaryDictionary::setDictionaryWordCheap(&aw,p);
anagram.push_back(&aw);
anagram_search(w,anagram,n,bail,bail?0:-1);
}
}

/*:30*/
#line 1003 "anagram.w"
;
generateHTML(cout,'3');
break;

case 3:
generateHTML(cout);
break;
}

/*:26*/
#line 954 "anagram.w"
;

return 0;
}

/*:25*/
#line 264 "anagram.w"


/*:6*/
#line 252 "anagram.w"


/*:5*/
