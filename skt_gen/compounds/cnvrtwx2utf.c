#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

extern void fgetword();

#define myPATH "SCLINSTALLDIR/converters"

void cnvrtwx2utf(char *in, char *out){
  int pid;
  FILE *fp;
  char fin[20];
  char fout[20];
  char cmd[100];

  pid = getpid();
  sprintf(fin,"TFPATH/tmp%d",pid);
  sprintf(fout,"TFPATH/result%d",pid);

  fp = fopen(fin,"w");
  fprintf(fp,"%s ",in);
  fclose(fp);

  sprintf(cmd,"%s/wx2utf8.sh < %s > %s",myPATH,fin,fout);
  system(cmd);

  fp = fopen(fout,"r");
  fgetword(fp,out,'\n');
  fclose(fp);
 // system ("rm fin fout");
}
