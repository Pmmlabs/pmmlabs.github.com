#include "stdafx.h"
#include "mpi.h"
#include <string.h>
#include <random>
#include <time.h>
#pragma warning(disable : 4996)
//3. Два вектора А и В размерности N распределены между процессами: значения векторов
//процессов с четнными номерами составляют вектор А, значения векторов процессов с нечетными
//номерами составляют вектор В. Вычислить скалярное произведение (А,В). Два процесса,
//содержащие соответствующие компоненты вектора, обмениваются сообщениями, один из них
//выполняет сложение и отправляет рещультат нулевому процессу, который вычисляет и выводит результат.

int _tmain(int argc, char* argv[])
{
	char message[24];
	int myrank,numprocs;
	int TAG=0;
	int m;
	MPI_Status status;
	MPI_Init(&argc,&argv);
	MPI_Comm_size(MPI_COMM_WORLD, &numprocs);
	if (numprocs<3) MPI_Abort(MPI_COMM_WORLD,0); // Нужно мининмум 3 процесса
	MPI_Comm_rank(MPI_COMM_WORLD,&myrank);
	if(myrank==0)
	{
		int N=0;
		printf("Enter N: ");
		do
			scanf("%d",&N);
		while (N<2);

		m = N/((numprocs-1)/2); // размерность кусков вектора 
		if (N % m != 0) m-=(2*m+1); // увеличить размерность и изменить знак, если N нацело не делится на m

		for (int i=1;i<=numprocs-1-(numprocs-1)%2;i++)
			MPI_Send(&m,1,MPI_INT,i,TAG,MPI_COMM_WORLD);
		int tmp_res,res=0;
		for (int i=1;i<=(numprocs-1)/2;i++)
		{
			MPI_Recv(&tmp_res,1,MPI_INT,MPI_ANY_SOURCE,TAG,MPI_COMM_WORLD,&status);
			res += tmp_res;
		}
		printf("Result: %d\n",res);
	}
	else if ((numprocs-1)%2==0 || myrank!=numprocs-1) // если я - не последний и нечетный, которому нет работы
	{
		MPI_Recv(&m,1,MPI_INT,0,TAG,MPI_COMM_WORLD,&status);
		bool not_full = m<0 &&
			(myrank==numprocs-1-(numprocs-1)%2 // я - последний процесс
			|| myrank==numprocs-2-(numprocs-1)%2); // или я - предпоследний процесс
		m=abs(m);
		int *x;
		x=new int[m];
		srand(time(NULL));
		char str[100]="Process: ";
		char buf[5];
		itoa(myrank,buf,10);
		strncat(str,buf,strlen(buf));
		strncat(str," array: ",8);
		for (int i=0; i<m; i++)
		{
			if (i==m-1 && not_full) x[i]=0; // если N нечетное, то m увеличена на 1
			else
				x[i]=rand()*myrank%100;
			itoa(x[i],buf,10);
			strncat(str,buf,strlen(buf));
			strncat(str,", ",2);
		}
		printf("%s\n",str);
		if (myrank%2==0) // если я - А, отправляю свой вектор процессу, у которого кусок В
			MPI_Send(&x,m,MPI_INT,myrank-1,TAG,MPI_COMM_WORLD);
		else // если я - В, перемножаю и отправляю мастеру
		{
			int *y;
			MPI_Recv(&y,m,MPI_INT,myrank+1,TAG,MPI_COMM_WORLD,&status);
			int res=0;
			for (int i=0;i<m;i++)
				res += x[i]*y[i];
			MPI_Ssend(&res,1,MPI_INT,0,TAG,MPI_COMM_WORLD);
		}
	}
	MPI_Finalize();
	return 0;
}