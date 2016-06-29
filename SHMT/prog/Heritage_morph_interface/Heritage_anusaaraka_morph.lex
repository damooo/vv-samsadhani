 int debug;
 char word[100];
 char gen[5][20];
 char num[5][20];
 char per[5][20];
 char vargaH[20];
 char pv[20];
 char vib[5][20];
 char prayogaH[5][30];
 char san[5][10];
 char lakAraH[5][40];
 char kqw[40];
 char kqw_prati[40];
 char prati[40];
 char paxI[5][40];
 char ans[1000];
 char tmp[200];
 char iic[100];
 int count;
 int sent_no;
 int word_no;
 int iic_count;
 int i;
%x IGNORE
%%
\<solution[ ]num=\"[0-9]+\"\>	{if(debug) { printf("found new solution\n");} sent_no++;}
\<form[ ]wx=\"[^\"]+/\"	{ if(strcmp(pv,"")){ strcpy(word,pv); strcat(word,"-");} 
			  else if( iic_count > 0) { strcat(word,"-");}
                          else {word[0] = '\0';}
                          strcat(word,yytext+10); 
                          word_no++;strcpy(ans,""); 
                          if(debug) {   printf("found form wx\n"); 
					printf("word = %s",word);
					printf("ans = %s\n",ans);
				    }
			}

\<tags[ ]phase=\"pv\"\>\<entry[ ]wx=\"[^\"]+/\"\/\>	{
			 strcpy(pv,yytext+28); 
                         count=0; 
			 word_no--;
			 if(debug) {printf(" found tags phase pv\n pv = %s",pv);}
			}
\<entry[ ]wx=\"[^\"]+/\"\/\>\<krid\>	{
			strcpy(kqw_prati,yytext+11);
			if(!strcmp(vargaH,"nA")) {strcpy(vargaH,"kqw_nA");}
			if(debug) {printf(" found krid = %s vargaH = %s",kqw_prati, vargaH);}
			}
\<entry[ ]wx=\"[^\"]+/\"	{ 
                                  if(strcmp(pv,"")) {
                                    strcpy(prati,pv);
				    strcat(prati,yytext+11); 
                                    strcpy(pv,"");
                                  } else 
				    strcpy(prati,yytext+11); 
                        	  if(debug) {printf(" read prati\n");}
				}

\<tags[ ]phase=\"noun\"\>	{strcpy(vargaH,"nA"); 
				 iic_count = 0;
				 if(debug) {printf(" in phase noun\n");}
				}
\<tags[ ]phase=\"unknown\"\>	{strcpy(vargaH,"UNKN"); 
				 iic_count = 0;
				 if(debug) {printf(" in phase noun\n");}
				}
\<tags[ ]phase=\"iic\"\>	{strcpy(vargaH,"sa-pU-pa"); 
                                 iic_count++;
                                 word_no--;
				 if(debug) {printf(" in phase iic\n");}
				}
\<tags[ ]phase=\"ifc\"\>	{strcpy(vargaH,"nA");
				 if(debug) { printf(" in phase ifc\n");}
				}
\<tags[ ]phase=\"unde\"\>	{strcpy(vargaH,"avy");}
\<tags[ ]phase=\"inde\"\>	{strcpy(vargaH,"avy");}
\<tags[ ]phase=\"root\"\>	{strcpy(vargaH,"KP");}

\<tag\>	{count=-1; 
	 if(debug) {printf(" new tag starts\n");}
	}

\<morpho_infl\>	{}
\<\/morpho_infl\>	{}
\<morpho_gen\>	{}
\<morpho_gen>[a-zA-Z]+	{strcpy(pv,yytext+12);
			 strcat(pv,"_");
			// Added 18 Jul 2015 to handle GH's new treatment of pvs
                        }
\<\/morpho_gen\>	{}
\<\/krid\>	{if(debug) {printf(" closed krid\n");}}
\<krid\>	{}
\<root\>	{}
\<\/root\>	{if(debug) {printf(" closed root\n");}}


\<nom\/\>	{strcpy(vib[count],"<viBakwiH:1>");}
\<voc\/\>	{strcpy(vib[count],"<viBakwiH:8>");}
\<acc\/\>	{strcpy(vib[count],"<viBakwiH:2>");}
\<ins\/\>	{strcpy(vib[count],"<viBakwiH:3>");}
\<i\/\>	{strcpy(vib[count],"<viBakwiH:3>");}
\<dat\/\>	{strcpy(vib[count],"<viBakwiH:4>");}
\<abl\/\>	{strcpy(vib[count],"<viBakwiH:5>");}
\<gen\/\>	{strcpy(vib[count],"<viBakwiH:6>");}
\<g\/\>	{strcpy(vib[count],"<viBakwiH:6>");}
\loc\/\>	{strcpy(vib[count],"<viBakwiH:7>");}

\<m\/\>	{strcpy(gen[count],"<lifgam:puM>");}
\<n\/\>	{strcpy(gen[count],"<lifgam:napuM>");}
\<f\/\>	{strcpy(gen[count],"<lifgam:swrI>");}
\<d\/\>	{strcpy(gen[count],"<lifgam:a>");}

\<sg\/\>	{strcpy(num[count],"<vacanam:1>");}
\<du\/\>	{strcpy(num[count],"<vacanam:2>");}
\<pl\/\>	{strcpy(num[count],"<vacanam:3>");}

\<thd\/\>	{strcpy(per[count],"<puruRaH:pra>");}
\<snd\/\>	{strcpy(per[count],"<puruRaH:ma>");}
\<fst\/\>	{strcpy(per[count],"<puruRaH:u>");}

\<part\/\>	{}
\<prep\/\>	{}
\<conj\/\>	{}
\<adv\/\>	{}
\<und\/\>	{}
\<ind\/\>	{}
\<iic\/\>	{}
\<unknown\/\>	{}

\<ca\/\>	{strcpy(san[count],"<sanAxiH:Nic>");}
\<des\/\>	{strcpy(san[count],"<sanAxiH:san>");}
\<int\/\>	{strcpy(san[count],"<sanAxiH:yaf>");}

\<ac\/>	{strcpy(prayogaH[count],"<prayogaH:karwari>"); strcpy(paxI[count],"<paxI:parasmEpaxI>");}
\<md\/>	{strcpy(prayogaH[count],"<prayogaH:karwari>"); strcpy(paxI[count],"<paxI:AwmanepaxI>");}
\<ps\/>	{strcpy(prayogaH[count],"<prayogaH:karmaNi>");strcpy(paxI[count],"<paxI:AwmanepaxI>");}

\<pr[ ]gana=[0-9]+\/\>	{strcpy(lakAraH[count],"<lakAraH:lat>");}
\<imp[ ]gana=[0-9]+\/\>	{strcpy(lakAraH[count],"<lakAraH:lot>");}
\<aor[ ]gana=[0-9]+\/\>	{strcpy(lakAraH[count],"<lakAraH:luf>");}
\<inj[ ]gana=[0-9]+\/\>	{strcpy(lakAraH[count],"<luf>");}
\<prps\/\>	{strcpy(lakAraH[count],"<lakAraH:lat>"); strcpy(prayogaH[count],"<prayogaH:karmaNi>");}
\<impps\/\>	{strcpy(lakAraH[count],"<lakAraH:lot><prayogaH:karmaNi>");}
\<optps\/\>	{strcpy(lakAraH[count],"<lakAraH:viXilif><prayogaH:karmaNi>");}
\<impftps\/\>	{strcpy(lakAraH[count],"<lakAraH:laf><prayogaH:karmaNi>");}
\<impft[ ]gana=[0-9]+\/\>	{strcpy(lakAraH[count],"<lakAraH:laf>");}
\<perfut\/\>	{strcpy(lakAraH[count],"<lakAraH:lut>");}
\<fut\/\>	{strcpy(lakAraH[count],"<lakAraH:lqt>");}
\<pft\/\>	{strcpy(lakAraH[count],"<lakAraH:lit>");}
\<cond\/\>	{strcpy(lakAraH[count],"<lakAraH:lqf>");}
\<ben\/\>	{strcpy(lakAraH[count],"<lakAraH:ASIrlif>");}

\<ppr[ ]gana=[1-9]\<ac\/\>	{strcpy(kqw,"<kqw_prawyayaH:Sawq_lat>"); }
\<ppr[ ]gana=[1-9]\<md\/\>	{strcpy(kqw,"<kqw_prawyayaH:SAnac_lat>"); }
\<ppr[ ]gana=[1-9]\<ps\/\>	{strcpy(kqw,"<kqw_prawyayaH:SAnac_lat>"); }

\<abs\/\>	{strcpy(kqw,"<kqw_prawyayaH:kwvA>"); strcpy(vargaH,"avykqw");}
\<inf\/\>	{strcpy(kqw,"<kqw_prawyayaH:wumun>"); strcpy(vargaH,"avykqw");}
\<pfp\/\>1	{strcpy(kqw,"<kqw_prawyayaH:yaw>"); /*printf("found krid pp\n"); Whether it is Nyaw / yaw / kyap ? */}
\<pfp\/\>2	{strcpy(kqw,"<kqw_prawyayaH:anIyar>"); /*printf("found krid pp\n"); */}
\<pfp\/\>3	{strcpy(kqw,"<kqw_prawyayaH:wavyaw>"); /*printf("found krid pp\n"); */}
\<pp\/\>	{strcpy(kqw,"<kqw_prawyayaH:kwa>"); /*printf("found krid pp\n");*/}
\<ppa\/\>	{strcpy(kqw,"<kqw_prawyayaH:kwavaw>"); /*printf("found krid pp\n");*/}

\<choice\>	{count++;}

\<\/choice\>	{}
\<morph\>	{}
\<\/morph\>	{}
\<stem\>	{}
\<\/stem\>	{}

\<\/tag\>	{  /* printf("vargaH = %s count = %d",vargaH, count); */
                /*printf("inside close tag\n");*/
                if (debug) {printf("%s\n",ans);}
                   if(strcmp(ans,"")) { strcat(ans,"/");}

                   if(debug) { printf("ans = %s\n",ans);}
		   for(i=0;i<=count;i++) {
                      if(i >= 1) { strcat(ans,"/");}
                      if(!strcmp(vargaH,"nA")) {
                         if(strcmp(iic,"") && (i == 0)){
                           sprintf(tmp,"%s-",iic);
			   strcat(ans,tmp);
                           tmp[0] = '\0';
                         }
                         sprintf(tmp,"%s<vargaH:%s>%s%s%s<level:1>",prati,vargaH,gen[i],vib[i],num[i]);
			 strcat(ans,tmp);
                         tmp[0] = '\0';
                      }
                      else if(!strcmp(vargaH,"KP")) {
                         if(strcmp(pv,"")){ 
                            sprintf(tmp,"%s_",pv);
			    strcat(ans,tmp);
                            tmp[0] = '\0';
                         }
                         sprintf(tmp,"%s%s%s%s%s%s%s<level:1>",prati,prayogaH[i],lakAraH[i],per[i],num[i],paxI[i],san[i]);
			 strcat(ans,tmp);
                         tmp[0] = '\0';
                      }
                      else if(!strcmp(vargaH,"avy")) {
                         sprintf(tmp,"%s<vargaH:%s><level:1>",prati,vargaH);
			 strcat(ans,tmp);
                         tmp[0] = '\0';
                      }
                      else if(!strcmp(vargaH,"avykqw")) {
                         if(strcmp(pv,"")){ 
                            sprintf(tmp,"%s_",pv);
			    strcat(ans,tmp);
                            tmp[0] = '\0';
                            if(!strcmp(kqw,"<kqw_prawyayaH:kwvA>")) { strcpy(kqw,"<kqw_prawyayaH:lyap>");}
                         }
                         sprintf(tmp,"%s<vargaH:avy>%s<level:1>",prati,kqw);
			 strcat(ans,tmp);
                         tmp[0] = '\0';
                      }
                      else if(!strcmp(vargaH,"sa-pU-pa")) {
                         if(!strcmp(iic,"")) { strcpy(iic,prati);}
                         else { strcat(iic,"-");strcat(iic,prati);}
                      }
                      else if(!strcmp(vargaH,"kqw_nA")) {
                         if(strcmp(iic,"") && (i == 0)){
                           sprintf(tmp,"%s-",iic);
			   strcat(ans,tmp);
                           tmp[0] = '\0';
                         }
                         if(strcmp(pv,"")){ 
                            strcat(tmp,pv);
                            strcat(tmp,"_");
			    strcat(ans,tmp);
                            tmp[0] = '\0';
                         }
                         sprintf(tmp,"%s%s<level:0><kqw_pratipadika:%s><vargaH:nA>%s%s%s%s",prati,kqw,kqw_prati,gen[i],vib[i],num[i],san[i]);
			 strcat(ans,tmp);
                         tmp[0] = '\0';
                      }
                      else if(!strcmp(vargaH,"UNKN")) {
                         sprintf(tmp,"%s",prati);
			 strcat(ans,tmp);
                         tmp[0] = '\0';
                      }
                   if(debug) { printf("i = %d ans = %s\n",i,ans);}
                  }
                  if(!strcmp(vargaH,"avykqw") || !strcmp(vargaH,"kqw_nA") || !strcmp(vargaH,"KP") || !strcmp(vargaH,"nA")){ strcpy(pv,""); strcpy(iic,"");}
                  /*printf("finished tag\n"); */
                }
\<\/tags\>	{ if((!strcmp(pv,"")) && (!strcmp(iic,""))){
                     if(word_no == 1) {
                       printf("%d.%d\t<s><a>\t%s\t%s\t\t%s\n",
                           sent_no,word_no,word,word,ans);
                     } else {
                       printf("%d.%d\t\t%s\t%s\t\t%s\n",
                           sent_no,word_no,word,word,ans);
                     } 
                  }
                  if(debug) {printf(" finished with tags\n");}
                    for(i=0;i<5;i++) { 
                      gen[i][0] = '\0';
                      num[i][0] = '\0'; 
                      per[i][0] = '\0'; 
                      vib[i][0] = '\0'; 
                      prayogaH[i][0] = '\0'; 
                      san[i][0] = '\0'; 
                      lakAraH[i][0] = '\0'; 
                      kqw[0] = '\0'; 
                      kqw_prati[0] = '\0'; 
                      paxI[i][0] = '\0';
                    }
                }
\<\/solution\>	{printf("\n");word_no = 0;
		  /* BEGIN IGNORE; */
                 if(debug) { printf(" solution complete\n");}}
\>      { } /*printf("end >\n");*/
.	{}
\n	{ if(debug) {printf(" ignore new line\n");}}
 /*
   <IGNORE>.	{} ignore other solutions
   <IGNORE>\n	{} ignore other solutions 
 */
%%
int 
main(int argc, char *argv[])
{
extern int count, sent_no, word_no,i;
extern int debug;
extern char word[100], gen[5][20], num[5][20], per[5][20], vargaH[20], pv[20], vib[5][20], prayogaH[5][30], san[5][10], lakAraH[5][40], kqw[40], kqw_prati[40], prati[40], paxI[5][40], ans[1000], tmp[200], iic[100];

debug = 0;

if(argc == 2) {
  if(index(argv[1],'D')) { 
     printf("debug = 1\n"); 
     debug = 1;
  }
}

sent_no = 0;
word_no = 0;
count = 0;
iic_count = 0;

word[0] = '\0';
vargaH[0] = '\0';
pv[0] = '\0';
prati[0] = '\0';
ans[0] = '\0';
tmp[0] = '\0';
iic[0] = '\0';

for(i=0;i<5;i++) { gen[i][0] = '\0';num[i][0] = '\0'; per[i][0] = '\0'; vib[i][0] = '\0'; prayogaH[i][0] = '\0'; san[i][0] = '\0'; lakAraH[i][0] = '\0'; kqw[0] = '\0'; kqw_prati[0] = '\0'; paxI[i][0] = '\0';}

return yylex();
}
