%{
#include "typeidentifier.tab.h"
%}
%%
[a-zA-Z]+	{strcpy(yylval.padainfo.word,yytext);return concept;}
	
\n	{ return '\n';}
\<	{ return '<';}
\>	{ return '>';}
\-	{ return '-';}
%%
