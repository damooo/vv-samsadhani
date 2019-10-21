  /* To tell compiler that we are not using unput and input features, and hence not to generate any warning */
%option nounput 
%option noinput
%%
^[0-9]+\.[2-9]	{}
^[0-9]+\.1[0-9]	{}
^[0-9]+\.[0-9]+	{ printf("%s",yytext);}
\n\n	{printf("<@br>");}
\n	{}
[ \t]	{ printf(" ");}
[a-zA-Z]+	{printf("%s",yytext);}
_	{printf(" ");}
.	{}
