// 3.Требуется вычислить значения суммы ряда в n точках хаданного интервала [A,B] с точностью e. Функция: ln(x+sqrt(x^2+1))
#include "stdafx.h"
#include "mpi.h"
#include <string.h>
#include <cstdlib>
#include <cmath>
#pragma warning(disable : 4996)
//функция приближённого вычисления ln(x+sqrt(x^2+1))
float Sum_Ln(float x,float eps)
{
	float xi = x;
	float sum = 0;
	float x_kv = x*x;
	int i=0;
	while (abs(xi/(2*i+1))>eps)
	{
		sum += xi/(2*i+1);
		i++;
		xi *= (-1)*x_kv*(2*i-1)/(2*i);
	}
	return sum;
}

int _tmain(int argc, char* argv[])
{
	int myrank,numprocs,n;
	float e;
	float *sendbuf_x;  //массив,в который мастер запишет иксы(буфер отправки)
	float *readbuf_x;  //буфер приёма иксов
	float *sendbuf_res;//буфер,в который рабочие процессы помещают результат 
	float *readbuf_res;//массив,в который мастер будет собирать результаты

	MPI_Init(&argc,&argv);
	MPI_Comm_size(MPI_COMM_WORLD, &numprocs);
	if (numprocs<2) MPI_Abort(MPI_COMM_WORLD,0); // Нужно мининмум 2 процесса
	MPI_Comm_rank(MPI_COMM_WORLD,&myrank);

	if(myrank==0)
	{
		float A=0,B=0;
		printf("Enter A: ");
		scanf("%f",&A);

		printf("Enter B: ");
		scanf("%f",&B);

		printf("Enter epsilon: ");
		do
		scanf("%f",&e);
		while (e<=0);

		printf("Enter N: ");
		do
		scanf("%d",&n);
		while (n<2); 

		sendbuf_x=new float[n];
		float ABN = (float)(B-A)/(n-1); //Расстояние между точками
		for (int i=0; i<n; i++)
			sendbuf_x[i]=A+i*ABN;        // Вычисление всех точек
	}
	else sendbuf_x=NULL;

	MPI_Bcast(&e,1,MPI_FLOAT,0,MPI_COMM_WORLD);//отправить всем эпсилон
	MPI_Bcast(&n,1,MPI_INT,0,MPI_COMM_WORLD);//отправить всем n
	int add = (int)(n % numprocs != 0); // 1 если есть остаток, 0 если нет
	readbuf_x=new float[n/numprocs+add];
	sendbuf_res=new float[2*(n/numprocs+add)];
	readbuf_res=new float[2*n];
	MPI_Scatter(sendbuf_x,n/numprocs+add,MPI_FLOAT,readbuf_x,n/numprocs+add,MPI_FLOAT,0,MPI_COMM_WORLD);
	
	float x;
	for (int i=0;i<n/numprocs+add;i++) //для каждого икс вычисляем приближённое и точное значение 
	{
		//взять очередной х из буфера 
		x=readbuf_x[i];
		if (abs(x) <=1)
		{
			sendbuf_res[2*i]=Sum_Ln(x,e); // в четных ячейках - приближенное значение
			sendbuf_res[2*i+1]=log(x+sqrt(x*x+1)); // в нечетных ячейках - точное значение
		}
	}
	//собрать результаты вычислений	
	MPI_Gather(sendbuf_res,2*(n/numprocs+add),MPI_FLOAT,readbuf_res,2*(n/numprocs+add),MPI_FLOAT,0,MPI_COMM_WORLD);
	//вывод результата
	if (myrank==0)
	{
		printf("x\t\tSumma\t\tExact value\n");
		for (int i=0; i<n;i++)
			printf("%f\t%f\t%f\n",sendbuf_x[i],readbuf_res[2*i],readbuf_res[2*i+1]);
	}
	MPI_Finalize();
	return 0;
}