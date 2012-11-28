#include "mpi.h"
#include <stdio.h>
#include <iostream>
#include <cmath>
#include <time.h>

void findmax ( int * invec, int * inoutvec, int * len, MPI_Datatype *dtype) 
{
	for (int i=0;i<*len;i++)
	{
		int res;
		if (invec[i]<1) res = 1;
		else res = pow(2,ceil(log10((double)invec[i])/log10((double)2)));
		if (res>=inoutvec[i]) inoutvec[i] = res;
	}
}

int main(int argc, char* argv[])
{
	const int n=5;
	int rank,size,data[n],result[n];
	MPI_Op op1;
	MPI_Init(&argc,&argv);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	srand(time(NULL));
	char str[100]="Process: ";
	char buf[5];
	itoa(rank,buf,10);
	strncat(str,buf,strlen(buf));
	strncat(str," array: ",8);
	for (int i=0;i<n;i++)
	{
		data[i] = (rand()*(rank+1)-rand()*2)%129; //диапазон от -128 до 128
		itoa(data[i],buf,10);
		strncat(str,buf,strlen(buf));
		strncat(str,", ",2);
		result[i]=0;
	}
	printf("%s\n",str);
	MPI_Op_create((MPI_User_function *)findmax,1,&op1);
	MPI_Reduce (&data,&result, n, MPI_INT, op1, 0, MPI_COMM_WORLD);
	MPI_Op_free(&op1);
	if (rank==0)
	{
		printf("Result: ");
		for (int i=0;i<n;i++)	
			printf("%d ",result[i]);
	}
	MPI_Finalize();
	return 0;
}