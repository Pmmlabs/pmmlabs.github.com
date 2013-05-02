//---------------------------------------------------------------------------

#pragma hdrstop

//---------------------------------------------------------------------------
 # include  <iostream>
 #include <cmath>
 //#include<stdlib.h>
 using namespace std;
#pragma argsused

int main()
{
 int  a [10][10];
 int min[10]; int max;
 int n,m,i,j,i1,j1,i2,j2;
 cout<<"vvedite kol-vo strok & stolbcov";
         cin>>n;
 cin>>m;
 randomize();
 for(i=1;i<=n;i++)
{
        for(j=1;j<=m;j++)
	{
                   a[i][j]= random(50);
	} 
}
                 cout<<"Matrix:\n";
for(i=1;i<=n;i++)
{
        for(j=1;j<=m;j++)
	{
                cout<<a[i][j]<<" ";
	}
	cout<<"\n" ;
}
for(i=1;i<=n;i++)
{
	min[i]=a[i][1];
	for(j=1;j<=m;j++)
	{
		if(a[i][j]<=min[i])
		{
		min[i]=a[i][j];
		j1=j;
		}
	} 
	cout<<"min[i]="<<min[i]<<" "; 
	cout<<"[i][j]="<<" "<<i<<" "<<j1<<"\n";
}  
max=min[1];
for(i=1;i<=n;i++)
{
         if(min[i]>max)
	{
 	  max=min[i];
 	  i1=i;
   	 }
 } 
cout<<"max="<<max<<" ";
cout<<"[i][j]="<<" "<<i1<<" "<<j1<<" ";
cin.get();
cin.get();
return 0;
}
//---------------------------------------------------------------------------

