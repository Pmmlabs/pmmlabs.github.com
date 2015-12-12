#include "stdafx.h"
#include <iostream>
#include <math.h>
using namespace std;
int main ( )
{
int zn,znak,n,g;
double s1,s2,se1,se2,sl,e,E,x,ch;
cout « " n= " ;
cin » n;
cout « " Vvedite x ot -1 do 1 " ;
cin » x;
cout « " Vvedite e " ;
cin » e;
s1=0;
s2=0;
ch=1/x;
zn=-1;
znak=-1;
int ks1=0;
int ks2=0;
se1=0;
se2=0;
for (int i=0; i<=n; i++)
{
ch=x*x;
znak=znak*(-1);
zn=zn+2;
sl=ch/zn;
s1=s1+znak*sl;
}

ch=1/x;
sl=0;
zn=-1;
znak=-1;

do
{
ch=x*x;
znak=znak*(-1);
zn=zn+2;
sl=ch/zn;
se1=se1+znak*sl;
ks1=ks1+1;
}
while (abs(sl)>e); 

ch=1/x;
sl=0;
zn=-1;
znak=-1;

do 
{
ch=x*x;
znak=znak*(-1);
zn=zn+2;
sl=ch/zn;
se2=se2+znak*sl;
ks2=ks2+1;
}
while (abs(sl)>e*10);



cout « "Summa slagaemih zadannogo vida " « s1 « endl;
cout « "Summa slagaemih cotorie bolshe E " « se1 « endl;
cout « "Summa slagaemih cotorie bolshe E " « se2 « endl;
cout « "Kollichestvo slagaemih ravno " « ks1 « endl;
cout « "Kollichestvo slagaemih ravno " « ks2 « endl;
cout « "Znachenie functsyy " « atan(x) « endl;
cin.get( );
cin.get( );
}