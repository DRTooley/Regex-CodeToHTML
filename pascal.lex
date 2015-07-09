 // A part of handout for CS441 Fall 2014  JWJ-CS-UK
	// Modified by YOUR_NAME
	// Program 1 CS441
	// September 18, 2014
	//flex specifications for JAVA HIGHLIHGHTING PROGRAM
	//Portions of the regular definitions are removed
	//Modify for PASCAL!
%{
  #include <stdlib.h>
  #include <unistd.h>
  #include <stdio.h>
  #include <time.h>
  #include <sys/wait.h>

  #include "hash.h"

// CSS Classes - Program uses CSS, not font tags
// java.css is external file, editable as you please.
#define		COMMENT_CSS		"COMMENT_COLOR"
#define		NUMBER_CSS		"NUMBER_COLOR"
#define		OPERATOR_CSS		"OPERATOR_COLOR"
#define		SEPARATOR_CSS		"SEPARATOR_COLOR"
#define		IDENTIFIER_CSS		"IDENTIFIER_COLOR"
#define		STRINGLITERAL_CSS	"STRINGLITERAL_COLOR"
#define		KEYWORD_CSS		"KEYWORD_COLOR"


  // some necessary globals
  FILE *fout, *fin;
  int my_index; 
  int linecount = 1;
  char *clean_text;

  struct tm *newtime;
  time_t aclock;

  char *hide_html();

  // function headers
  void open_files();
  void close_files();
  void process();
  void usage(char *);

// Keywords, OPs, Seps, etc have been changed to java's lexical rule
// The order even follows the java docs.. just to make sure I didn't miss any.
// Remove includes, java doesnt get those 

// Also replaced font tags below with CSS classes
// Some tokens, rules and actions has been removed
%}

OLD_I_LINE_COMMENT [(\*|{].*[\*)|}]
OLD_N_LINE_COMMENT "(*"([^\n])*
OLD_END_COMMENT_LINE (.)*"*)"
NEW_I_LINE_COMMENT [{].*[}]
NEW_N_LINE_COMMENT [{]([^\n])*
NEW_END_COMMENT_LINE (.)*["}"]
C_I_LINE_COMMENT "\/\*".*"\*\/"
C_N_LINE_COMMENT "\/\*"([^\n])*
C_END_COMMENT_LINE (.)*"\*\/"
STRING_LITERAL ("\""("\\\""|[^"\n])*"\"")|("\'"("\\\'"|[^'\n])*"\'")
N_LINE_DQ "\""("\\\""|[^"\n])*
N_LINE_SQ "\'"("\\\'"|[^'\n])*
N_LINE_DQ_MEAT ("\\\""|[^"\n])*
N_LINE_SQ_MEAT ("\\\'"|[^'\n])*
END_N_LINE_DQ [^"\n]*"\""
END_N_LINE_SQ [^'\n]*"\'"
DIGIT      [0-9]
KEYWORD	(?i:(abstract|absolute|all|array|as|asm(?:name)?|attribute|begin|bindable|c|case|c_language|class|const(?:ructor)?|destructor|do(?:wnto)?|else|end|export(?:s)?|external|far|file|finalization|for|forward|function|goto|if|implementation|import|inherited|initialization|interface|interrupt|is|label|library|module|name|near|nil|object|of|only|operator|otherwise|packed|private|procedure|program|property|protected|public|published|qualified|record|repeat|resident|restricted|segment|set|then|to|type|unit|until|uses|value|var|view|virtual|while|with))
DATATYPES (?i:(integer|int64|byte|shortint|smallint|word|cardinal|longint|longword|qword|real|single|double|extended|comp|currency|boolean|bytebool|wordbool|longbool))
OPERATOR  "."|":"|":="|"="|"+"|"-"|"*"|"/"|">"?("="|"<"|">")|"<"?("="|"<"|">")|(?i:(and(?:_then)?|div|mod|not|or(?:_else)?|pow|sh{1}?(l|r)|xor|include|exclude|in|is|as))
SEPARATOR  "("|")"|"{"|"}"|";"|","|" "|"\t"|"["|"]"
IDENTIFIER [a-zA-Z][a-zA-Z0-9]*  

%x LONG_COMMENT LONG_DQ_STRING LONG_SQ_STRING
%%
{OLD_I_LINE_COMMENT}                  { fprintf( fout, "<span class=%s>%s</span>", COMMENT_CSS, hide_html(yytext));  free(clean_text); }
{NEW_I_LINE_COMMENT}                  { fprintf( fout, "<span class=%s>%s</span>", COMMENT_CSS, hide_html(yytext));  free(clean_text); }
{C_I_LINE_COMMENT}                  { fprintf( fout, "<span class=%s>%s</span>", COMMENT_CSS, hide_html(yytext));  free(clean_text); }
{OLD_N_LINE_COMMENT}                  { fprintf( fout, "<span class=%s>%s</span>", COMMENT_CSS, hide_html(yytext)); free(clean_text); BEGIN(LONG_COMMENT); }
{NEW_N_LINE_COMMENT}                  { fprintf( fout, "<span class=%s>%s</span>", COMMENT_CSS, hide_html(yytext)); free(clean_text); BEGIN(LONG_COMMENT); }
{C_N_LINE_COMMENT}                  { fprintf( fout, "<span class=%s>%s</span>", COMMENT_CSS, hide_html(yytext)); free(clean_text); BEGIN(LONG_COMMENT); }
<LONG_COMMENT>{OLD_END_COMMENT_LINE}  { fprintf( fout, "<span class=%s>%s</span>", COMMENT_CSS, hide_html(yytext)); free(clean_text); BEGIN(INITIAL); }
<LONG_COMMENT>{NEW_END_COMMENT_LINE}  { fprintf( fout, "<span class=%s>%s</span>", COMMENT_CSS, hide_html(yytext)); free(clean_text); BEGIN(INITIAL); }
<LONG_COMMENT>{C_END_COMMENT_LINE}  { fprintf( fout, "<span class=%s>%s</span>", COMMENT_CSS, hide_html(yytext)); free(clean_text); BEGIN(INITIAL); }
<LONG_COMMENT>.*                   { fprintf( fout, "<span class=%s>%s</span>", COMMENT_CSS, hide_html(yytext)); free(clean_text); }

{DIGIT}+                       { fprintf( fout, "<span class=%s><b>%s</b></span>", NUMBER_CSS, yytext);  }     
{DIGIT}+"."{DIGIT}*               { fprintf( fout, "<span class=%s><b>%s</b></span>", NUMBER_CSS, yytext);  }
{DIGIT}.{DIGIT}**E{DIGIT}+         { /*removed*/  }
{STRING_LITERAL}                      { fprintf( fout, "<span class=%s>%s</span>", STRINGLITERAL_CSS, hide_html(yytext)); free(clean_text); }
{N_LINE_DQ}                           { fprintf( fout, "<span class=%s>%s</span>", STRINGLITERAL_CSS, hide_html(yytext)); free(clean_text); BEGIN(LONG_DQ_STRING); }
<LONG_DQ_STRING>{N_LINE_DQ_MEAT}      { fprintf( fout, "<span class=%s>%s</span>", STRINGLITERAL_CSS, hide_html(yytext)); free(clean_text); }
<LONG_DQ_STRING>{END_N_LINE_DQ}       { fprintf( fout, "<span class=%s>%s</span>", STRINGLITERAL_CSS, hide_html(yytext)); free(clean_text); BEGIN(INITIAL); }
{N_LINE_SQ}                           { fprintf( fout, "<span class=%s>%s</span>", STRINGLITERAL_CSS, hide_html(yytext)); free(clean_text); BEGIN(LONG_SQ_STRING); }
<LONG_SQ_STRING>{N_LINE_SQ_MEAT}      { fprintf( fout, "<span class=%s>%s</span>", STRINGLITERAL_CSS, hide_html(yytext)); free(clean_text); }
{SEPARATOR}  { fprintf( fout, "<span class=%s><b>%s</b></span>", NUMBER_CSS, yytext);  }
{KEYWORD}|{DATATYPES}  { fprintf( fout, "<span class=%s><b>%s</b></span>", KEYWORD_CSS, yytext);  }
{OPERATOR} { fprintf( fout, "<span class=%s>%s</span>", OPERATOR_CSS, yytext);}
{IDENTIFIER}+ { fprintf( fout, "<span class=%s>%s</span>", IDENTIFIER_CSS, yytext); add_identifier(yytext);  }
<INITIAL,LONG_COMMENT,LONG_DQ_STRING,LONG_SQ_STRING>\n          { fprintf( fout, "\n<a name=%d>%4d</a>: ", linecount, linecount); linecount++; }
%%

// simple main, calls helper functions
int main(int argc, char *argv[]) {
  open_files(argc, argv);
  process(argv);
  close_files();

  return 0;
}

// helper to open files
void open_files(int argc, char *argv[]) {
  if((argc == 2 && strcmp(argv[1], "-h") == 0) ||
     (fin = fopen(argv[1], "r")) == NULL ||
     (fout = fopen(argv[2], "w")) == NULL)
    usage(argv[0]);
}

// helper to close files
void close_files() {
  close((int) fin);
  close((int) fout);
}

// start writing the page, set up line count, run the parser, print the table
void process(char *argv[]) {
  init_table();

  time( &aclock );
  newtime = localtime( &aclock );
// CSS load added
  fprintf(fout, "<html> <head><link href=\"pascal.css\" rel=\"stylesheet\" type=\"text/css\"/> </head> <body bgcolor=#ffffff>\n%s <br>", argv[0]);
  fprintf(fout, "Source: %s<br>Target: %s<br>Date: %s<br>", argv[1], argv[2], asctime( newtime ));
  fprintf(fout, "Name: David Tooley<br>Class: CS 441 Fall 2014");
  fprintf(fout, "<hr><pre><a name=%d>%4d</a>: ", linecount, linecount);
  linecount++;

  yyin = fin;
  yylex();

  fprintf(fout, "<hr></pre>\n");
  fprintf(fout, "Done parsing %s(%d lines)<br><br><u>Variable and instance list</u><br>\n", argv[1], linecount-1);
  output_and_delete_table();


  fprintf(fout, "<br></body></html>");

}

// helper to make < look like &lt and > look like &gt
char *hide_html(char *text) {
  clean_text = malloc(strlen(text)*4);
  memset(clean_text, '\0', strlen(text)*4);

  for(my_index = 0; my_index < strlen(text); my_index++)
    if(text[my_index] == '<')
      strncat(clean_text, "&lt;", 4);
    else if(text[my_index] == '>')
      strncat(clean_text, "&gt;", 4);
    else
      strncat(clean_text, text+my_index, 1);

  return clean_text;
}

// usage helper
void usage(char *argv) {
  printf("Usage: %s <input.[pas]> <output.html>\n", argv);
  printf("       Processes input.[c,cpp] and creates output.html from it\n");
  printf("   or: %s -h\n", argv);
  printf("       Output usage\n");
  close_files();
  exit(1);
}
