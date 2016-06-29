#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

#define myPATH "SCLINSTALLDIR/skt_gen/compounds"
extern void fgetword();

void get_sandhied_word (char *prAwipaxikam1, char *prAwipaxikam2, char *sandhiw)
{
    char cmd[200];
    FILE *fp;
    char fout[20];
    char f1out[20];

    int pid;

    pid = getpid();
    sprintf(fout,"TFPATH/sandhi%d",pid);
    sprintf(f1out,"TFPATH/1sandhi%d",pid);

    cmd[0]='\0';
    sprintf(cmd,"%s/main_sandhi.pl %s+%s > %s",myPATH,prAwipaxikam1,prAwipaxikam2,fout);
    system(cmd);
    sprintf(cmd,"cut -d, -f1 %s > %s ",fout,f1out);
    system(cmd);
    if((fp=fopen(f1out,"r"))==NULL)
    {
      printf("@Error @in @f1out @opening\n");
      exit(0);
    } else {
      fgetword(fp,sandhiw,'\n');
      fclose(fp);
    }
    sprintf(cmd,"rm %s %s",fout,f1out);
    system(cmd);
}
