/*
##############################################################################
#
#  Copyright (C) Vineet Chaitanya 1987-2002 and  Amba Kulkarni 1995-2016
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation; either
#  version 2 of the License, or (at your option) any later
#  version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

##############################################################################
*/
 /* BUG: 
    This program does not work well when the file ends with a consonant. 
    An additional blank space or . is to be entered to get the final halant. 
    AMBA: 15th July 2015 */
 char map[]="01234567890123456789012345678901234567890123456789012345678901234ÚË¹Àâ¼¶£Ü»´L¢ÁæÉQÖÕ¾ÞVÃÅYé      ¤Ê¸¿á·µØÛº³ÑÌÆåÈßÏ×½ÝÔÂÄÍ¡ ";
 char tmp;
NUKTA Z
OPERATOR_V V
OPERATOR_Y Y
SPECIAL_CATEGORY [zMH]
VOWEL_A a
VOWEL_Q Q
VOWEL_L L
VOWEL_REMAINING [AiIuUqeEoO]
CONSONANT [kKgGfcCjJFtTdDNwWxXnpPbBmyrlvSRsh]
ROM_WORD [A-Za-z0-9]+
%option noinput
%option nounput
%x CONS 
%%
\\\|					{
					printf("ðµ");
					}
\\_					{
					printf("ð¸");
					}
@{ROM_WORD}				{printf("%s",yytext+1);}
@\.					{printf("%s",yytext+1);}

{CONSONANT}				{
					printf("%c",map[(int)yytext[0] ]);BEGIN CONS;
					}

z{NUKTA}				{
					printf("¡é");
					}
\.					{
					printf("ê");
					}
\.{NUKTA}				{
					printf("êé");
					}
{NUKTA}					{
					printf("êé");
					}
<CONS>I{NUKTA}				{
					printf("Üé");
					BEGIN INITIAL;
					}

<CONS>{NUKTA}				{
					printf("èêé");
					BEGIN INITIAL;
					}

<CONS>{VOWEL_A}				{BEGIN INITIAL;}

<CONS>{VOWEL_Q}				{
					printf("ßé");
					BEGIN INITIAL;
					}

<CONS>{VOWEL_L}				{
					printf("Ûé");
					BEGIN INITIAL;
					}

<CONS>{VOWEL_REMAINING}			{
					printf("%c",map[(int)yytext[0] ]);
					BEGIN INITIAL;
					}

<CONS>{VOWEL_REMAINING}{OPERATOR_V}+ 	{
					tmp = map[(int)yytext[0] ]-yyleng+1;
					/*printf("%c",map[yytext[0] ]-yyleng+1); 
This produces a warning: 
format %c expects type int, but argument 2 has type yy_size_t
Hence everywhere a 'tmp' variable is introduced, and then it is printed.
*/
					printf("%c",tmp);
					BEGIN INITIAL;
					}

<CONS>{VOWEL_REMAINING}{OPERATOR_Y}+ 	{
					tmp = map[(int)yytext[0] ]+yyleng-1;
					/*printf("%c",map[yytext[0] ]+yyleng-1); */
					printf("%c",tmp);
					BEGIN INITIAL;
					}

<CONS>{CONSONANT}			{
					printf("è%c",map[(int)yytext[0] ]);
					}

<CONS>{CONSONANT}{OPERATOR_V}+		{
					tmp = map[(int)yytext[0] ]-yyleng+1;
					/*printf("è%c",map[yytext[0] ]-yyleng+1);*/
					printf("è%c",tmp);
					}

<CONS>{CONSONANT}{OPERATOR_Y}+		{
					tmp = map[(int)yytext[0] ]+yyleng-1;
					/*printf("è%c",map[yytext[0] ]+yyleng-1);*/
					printf("è%c",tmp);
					}

<CONS>(.|\n)				{
					printf("è%c",yytext[0]);
					BEGIN INITIAL;
					}
{VOWEL_REMAINING}			{
					printf("%c",map[(int)yytext[0] ]-53);
					}

{VOWEL_A}				{
					printf("%c",map[(int)yytext[0] ]);
					}

{VOWEL_Q}				{
					printf("ªé");
					}

{VOWEL_L}				{
					printf("¦é");
					}
{SPECIAL_CATEGORY}			{
					printf("%c",map[(int)yytext[0] ]);
					}

{CONSONANT}{OPERATOR_V}+		{
					tmp = map[(int)yytext[0] ]-yyleng+1;
				/*	printf("%c",map[yytext[0] ]-yyleng+1); */
					printf("%c",tmp);
					BEGIN CONS;
					}

{CONSONANT}{OPERATOR_Y}+		{
					tmp = map[(int)yytext[0] ]+yyleng-1;
				/*	printf("%c",map[yytext[0] ]+yyleng-1); */
					printf("%c",tmp);
					BEGIN CONS;
					}

{VOWEL_REMAINING}{OPERATOR_V}+		{
					tmp = map[(int)yytext[0] ]-53-yyleng+1;
				/*	printf("%c",map[yytext[0] ]-53-yyleng+1); */
					printf("%c",tmp);
					}

{VOWEL_REMAINING}{OPERATOR_Y}+		{
					tmp = map[(int)yytext[0] ]-53+yyleng-1;
				/*	printf("%c",map[yytext[0] ]-53+yyleng-1); */
					printf("%c",tmp);
					}


{VOWEL_A}{OPERATOR_V}+			{
					tmp = map[(int)yytext[0] ]-yyleng+1;
				/*	printf("%c",map[yytext[0] ]-yyleng+1); */
					printf("%c",tmp);
					}

{VOWEL_A}{OPERATOR_Y}+			{
					tmp = map[(int)yytext[0] ]+yyleng-1;
				/*	printf("%c",map[yytext[0] ]+yyleng-1); */
					printf("%c",tmp);
					}
\.Y					{
					printf("êé");
					}

