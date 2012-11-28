#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#pragma warning(disable : 4996)

#define m 6
#define n 5

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

	int blocklength[m-1];
	int displacement[m-1];

	blocklength[0]=n+2; // перва€ строка и начало второй строки
	for (int i=1;i<m-2;i++)    
		blocklength[i]=3;
	blocklength[m-2]=n+1; // последний элемент предпоследней строки и последн€€ строка

	displacement[0]=0;
	for (int i=1;i<m-1;i++)
		displacement[i]=(i+1)*n-1;

	MPI_Datatype My_Type;
	MPI_Type_indexed(m-1,blocklength,displacement,MPI_INT,&My_Type);
	MPI_Type_commit(&My_Type);

	int Matr[m][n];
	for(int i = 0; i < m; i ++) 
		for(int j = 0; j < n; j ++)
			Matr[i][j]=myrank;
	PrintMatrix(Matr, 0); // matrix before
	if (0==myrank)
		MPI_Send(&Matr[0][0],1,My_Type,1,tag,MPI_COMM_WORLD);  //отправл€ем сообщение типа typeFive процессу P(0)      
	else if (1==myrank)
	{
		MPI_Recv(&Matr[0][0],1,My_Type,0,tag,MPI_COMM_WORLD,&status);	 
		PrintMatrix(Matr,1); // matrix after
	}
	MPI_Type_free(&My_Type);
	MPI_Finalize();

	return 0;
}