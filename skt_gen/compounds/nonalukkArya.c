#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "struct.h"

void subluk();
void cnvrtwx2utf();
void cnvrtutfd2r();
void fgetword();
void call_pUrvapaxalex();

char encoding[100];
char p1_utf[300];
char p2_utf[300];
struct prAwipaxikam prAwi;
char subanwam[100];
char samAsAnwa[100];
char samAsaprakAra[100];
int divid;
char p1[100];
char p2[100];

int main (int argc, char *argv[]) {

char sup1[30];
char sup2[30];
char p1_utfr[300];
char p2_utfr[300];

  strcpy(encoding,argv[1]);
  strcpy(p1,argv[2]);
  strcpy(sup1,argv[3]);
  strcpy(p2,argv[4]);
  strcpy(sup2,argv[5]);
  strcpy(samAsAnwa,argv[6]);
  strcpy(samAsaprakAra,argv[7]);
  divid = atoi(argv[8]);

  cnvrtwx2utf(p1,p1_utf);
  cnvrtwx2utf(p2,p2_utf);

  if(!strcmp(encoding,"RMN")){
    cnvrtwx2utf(p1_utf,p1_utfr);
    cnvrtwx2utf(p2_utf,p1_utfr);

    strcpy(p1_utfr, p1_utf);
    strcpy(p2_utfr, p2_utf);
  }

  // printf("calling subluk with samAsAnwa = %s",samAsAnwa);
  subluk(p1_utf,sup1,p2_utf,sup2,samAsAnwa);
  // printf("calling pUrvapaxa\n");
  call_pUrvapaxalex();
  return 1;
}

void subluk (char p1[100], char s1[10], char p2[100], char s2[10], char sp[100]) {

 char s1utf[30]; /* utf takes 3 times space */
 char s2utf[30]; /* utf takes 3 times space */
 char sputf[100];

 char s1utfr[30];
 char s2utfr[30];
 char sputfr[100];

 char p1_utfr[100];
 char p2_utfr[100];

 cnvrtwx2utf(s1,s1utf);
 cnvrtwx2utf(s2,s2utf);
 cnvrtwx2utf(sp,sputf);

 if(!strcmp(encoding,"RMN")) {
    cnvrtutfd2r(s1utf,s1utfr);
    cnvrtutfd2r(s2utf,s2utfr);
    cnvrtutfd2r(sputf,sputfr);
    cnvrtutfd2r(p1_utf,p1_utfr);
    cnvrtutfd2r(p2_utf,p2_utfr);
 }
 printf("<table><tr><td>");
 if(sp[0] == '\0')
   if (!strcmp(encoding,"RMN"))
   printf("<font color=\"blue\">%s+<font color=\"blue\">[%s] %s+<font color=\"blue\">[%s]  <font color=\"red\"> supo dhātuprātipadikayoḥ 2.4.71</font> </td> ", p1_utfr,s1utfr,p2_utfr,s2utfr);
    else 
     printf("<font color=\"blue\">%s+<font color=\"blue\">[%s] %s<font color=\"blue\">+[%s]  <font color=\"red\">सुपो धातुप्रातिपदिकयोः 2.4.71</font> </td>", p1,s1utf,p2,s2utf);
 else 
   if (!strcmp(encoding,"RMN"))
     printf("<font color=\"blue\">%s+<font color=\"blue\">[%s] %s<font color=\"blue\">+[%s] %s <font color=\"red\"> supo dhātuprātipadikayoḥ 2.4.71</font> </td> ", p1_utfr,s1utfr,p2_utfr,s2utfr,sputfr);
    else 
     printf("<font color=\"blue\">%s+<font color=\"blue\">[%s] %s+<font color=\"blue\">[%s] %s <font color=\"red\">सुपो धातुप्रातिपदिकयोः 2.4.71</font> </td>", p1,s1utf,p2,s2utf,sputf);
}
