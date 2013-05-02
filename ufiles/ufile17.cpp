//ƒан файл с целыми числами . определить €вл€етс€ ли последовтельность  упор€доченна€ по возрастанию

#include <stdafx.h>
#include <iostream>
#include <stdio.h>
using namespace std;

int main()
{

 FILE *fp;
 fp=fopen("in.txt","r");
 char ch;
 int chis=0,j,k,masChis[80],masKol[80],schet=0; 
 for (int i=0; i<80; i++) {masChis[i]=-8000; masKol[i]=0; }

 while((ch=fgetc(fp)) != EOF)
 if (ch!=' ') 
 {
 j=ch-48; 
 chis=chis*10+j;
 }
 else {
 j=0;
 while (masChis[j]!=(-8000)) j++;
 masChis[j]=chis;
 masKol[j]+=1; 
 schet++;
 chis=0;
 k=0;
 }

 for (int i=1; i<schet; i++) if (masChis[i-1]>=masChis[i]) k=1;
 if (k==1) cout<< "net\n";
 else cout<< "da\n";

fclose(fp);

cin>> ch;
 return 0;
}