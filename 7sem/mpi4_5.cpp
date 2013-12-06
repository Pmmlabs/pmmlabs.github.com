#include "stdafx.h"
#include <mpi.h>
#include <list>
#include <random>
#include <iostream>
#include <string>
using namespace std;

#pragma warning(disable : 4996)

#define m 6
#define n 6

void PrintMatrix(int (*arr)[n], int num)
{
	char message[200] = "Matrix ";
	strncat_s(message,(num==0 ? "before" : "after "),6);
	strncat_s(message,":\n",3);
	char buf[5];
	for (int i=0;i<m;i++)
	{
		for (int j=0;j<n;j++)
		{
			_itoa_s(arr[i][j],buf,10);
			strncat_s(message,buf,strlen(buf));
			strncat_s(message," ",1);
		}
		strncat_s(message,"\n",2);
	}
	printf("%s\n",message);
}
// v vvvvv
// v v   v
// v v   v
// vvvvvvv
int main (int argc, char *argv[])
{
	int myrank, tag=0;
	MPI_Status status;
	MPI_Init(&argc,&argv);
	MPI_Comm_rank(MPI_COMM_WORLD,&myrank);

	int blocklength[m];
	int displacement[m];
    blocklength[0]=n; //первая строка
	displacement[0]=0;
   
    int row=1;
    for (int i = 1; i < m-1; i++)
			{
			   blocklength[i]=1;
               displacement[i]=(n-1)*(row+1);
               row++;
			}

	 blocklength[m-1]=n; // последняя строка
	 displacement[m-1]=(m-1)*n;

	MPI_Datatype My_Type;
	MPI_Type_indexed(m,blocklength,displacement,MPI_INT,&My_Type);
	MPI_Type_commit(&My_Type);

	int Matr[m][n];
	for(int i = 0; i < m; i ++) 
		for(int j = 0; j < n; j ++)
			Matr[i][j]=myrank;
	if (0==myrank)
	{

		MPI_Send(&Matr[0][0],1,My_Type,1,tag,MPI_COMM_WORLD);  //отправляем сообщение типа typeFive процессу P(0)      
	}
	else if (1==myrank)
	{
		PrintMatrix(Matr, 0); // matrix before
		MPI_Recv(&Matr[0][0],1,My_Type,0,tag,MPI_COMM_WORLD,&status);	 
		PrintMatrix(Matr,1); // matrix after
	}
	MPI_Type_free(&My_Type);
	MPI_Finalize();
	return 0;
}
