//---------------------------------------------------------------------------

#pragma hdrstop
#pragma argsused
//---------------------------------------------------------------------------
 #include <iostream>  ;
 #include <cmath> ;
 using namespace std;

int main()
{
int N,R,i,I,j;
float x,E,result,S,s1,s2,P;
double k;
cout<<"vvedite x,N,E";
cin>>x;
cin>>N;
cin>>E;

R=1;
i=0;
I=0;
S=0;
result=0;
s1=0;
s2=0;
if(N>=1)
{
if ((x>-R)&&(x<R))
{
j=0;
for (j=0;j<=N-1;j++)
{
k= pow(-1.0,j);
          result = (1+j)*(pow(x,(j)))*k;

if (abs(result)>E)
{
s1=s1+result;
i=i+1;
}
if (abs(result)>10*E)
{
s2=s2+result;
I=I+1;
}
S=S+result;
result=0;
}
 P=abs((1/pow((1+x),2 ))-abs(S));
  cout<<"summa vsex 4lenov"<<S<<"\n";
  cout<<"Summa chlenov>E ="<<s1<<"\n";
  cout<<"Elementov bolshic E ="<<i<<"\n";
   cout << "CyMMa chleHoB > 10E PaBHa " << s2 << "\n";
   cout << "EleMeHToB bol'shih 10E " << I << "\n";
   cout << "Pa3HoCTb PaBHa " << P << "\n";

  }
    else 
	{
		cout << "x He legit B proMegyTke (-R,R)\n";
	}
   }
   else
   {
	   cout << "N men'she 0, bit He MogeT\n";
   }


cout<<"result is"<<result<<"\n" ;
cin.get();
cin.get();

        return 0;
}
//---------------------------------------------------------------------------


