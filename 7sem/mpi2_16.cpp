
#include "stdafx.h"
#include <mpi.h>
#include <iostream>
#include <string>
#include <vector>
#include <math.h>

#define MPI_ROOT_PROCESS 0



double GetFunctionValue(double x)
{
	//Левая часть функции	
	return (exp(x)-exp(-x))/2;
}

double GetApproxValue(double x, double eps)
{
	//правая часть функции
	double result = x;
	double a = x; 
	double s=0;
	int i=1;

	while (abs(s-result)>eps)
	{
		s=result;
		a=a*x*x/(2*i*(2*i+1));
		result+=a;
		i++;
	}
	return result;
}

int _tmain(int argc, char* argv[])
{

	MPI_Init(&argc,&argv);
	// Получаем число процессов
	int procCount;
	MPI_Comm_size(MPI_COMM_WORLD,&procCount);

	// Получаем ранг процесса
	int rank;
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);

	if (rank == MPI_ROOT_PROCESS)
	{
	
		double A,B;
		do
		{
		std::cout<<"ENTER A and B\n";
		std::cin>>A>>B;
		}

		while (A>=B);
		double eps;
		do
		{
		std::cout<<"ENTER epsylon\n";
		std::cin>>eps;
		}

		while (eps<=0 || eps>=1);
		int N;
		do
		{
			std::cout<<"ENTER count of points\n";
			std::cin>>N;
		}
		while (N<2);

		// Создаём массив точек, для которых будем считать функцию
		double *pointVector = new double[N];
		double step = (B-A)/(N-1);
		double cv = A;
		for (int i=1;i<N;i++)
		{
			pointVector[i-1] = cv;
			cv+=step;
		}
		
		pointVector[N-1] = B;
		

		// Отправляем точность
		MPI_Bcast(&eps,1,MPI_DOUBLE,MPI_ROOT_PROCESS,MPI_COMM_WORLD);
		
		// Точные значения функции
		double *accValues = new double[N];
		
		// Приближённые значения
		double *approxValues = new double[N]; 

		int sendCount = N / procCount;
	
		if (N % procCount == 0)  // Если количество процессов кратно числу точек
		{ 
			// Отправляем процессам сообщение с количеством точек
			MPI_Bcast(&sendCount,1,MPI_INT,MPI_ROOT_PROCESS,MPI_COMM_WORLD);
			
			// Отправляем сами точки
			MPI_Scatter(pointVector,sendCount,MPI_DOUBLE,pointVector,sendCount,MPI_DOUBLE,MPI_ROOT_PROCESS,MPI_COMM_WORLD);
			
			// Считаем функцию в своих точках
			for (int i = 0;i<sendCount;i++)
			{
				accValues[i]=GetFunctionValue(pointVector[i]);
				approxValues[i] = GetApproxValue(pointVector[i],eps);
			}
			
			// Принимаем точные значения
			MPI_Gather(accValues,sendCount,MPI_DOUBLE,accValues,sendCount,MPI_DOUBLE,MPI_ROOT_PROCESS,MPI_COMM_WORLD);
			
			// Принимаем приближённые значения
			MPI_Gather(approxValues,sendCount,MPI_DOUBLE,approxValues,sendCount,MPI_DOUBLE,MPI_ROOT_PROCESS,MPI_COMM_WORLD);
			
		}
		// если не кратно числу точек определить сколько кому отправлять
		else
		{
			// Отправляем сообщение другим процессам готовится к векторному приёму/передаче
			{
				int tmp = -1;
				MPI_Bcast(&tmp,1,MPI_INT,MPI_ROOT_PROCESS,MPI_COMM_WORLD);
			}
			// Формируем массив смещений и массив с числом элементов (смещения считаются в элементах от начала массива)
			int *sendArray = new int[procCount];
			int *offsetArray = new int[procCount];
			for (int i = 0;i<procCount;i++)
			{
				sendArray[i] = sendCount;
			}
			for (int i = 0; i<N%procCount;i++)
				sendArray[i]++;
			offsetArray[0]=0;
			for (int i=1;i<procCount;i++)
			{
				offsetArray[i]= sendArray[i-1]+offsetArray[i-1];
			}
			
			// Отправляем количество элементов
			MPI_Scatter(sendArray,1,MPI_INT,&sendArray[0],1,MPI_INT,MPI_ROOT_PROCESS,MPI_COMM_WORLD);
			// Отправляем данные
			MPI_Scatterv(pointVector,sendArray,offsetArray,MPI_DOUBLE,pointVector,sendArray[0],MPI_DOUBLE,MPI_ROOT_PROCESS,MPI_COMM_WORLD);
			for (int i = 0;i<sendArray[0];i++)
			{
				accValues[i]=GetFunctionValue(pointVector[i]);
				approxValues[i] = GetApproxValue(pointVector[i],eps);
			}
			
			// Принимаем точные значения
			MPI_Gatherv(accValues,sendArray[0],MPI_DOUBLE,accValues,sendArray,offsetArray,MPI_DOUBLE,MPI_ROOT_PROCESS,MPI_COMM_WORLD);
			// Принимаем приближенные значения
			MPI_Gatherv(approxValues,sendArray[0],MPI_DOUBLE,approxValues,sendArray,offsetArray,MPI_DOUBLE,MPI_ROOT_PROCESS,MPI_COMM_WORLD);
		}
		
		// Выводим точный результат 15 символов после запятой,с нулями справа и знаками
		std::cout.precision(15);
		std::cout.setf(std::ios::fixed | std::ios::showpos);
		std::cout<<"point              Accurate value     Approximate value\n";
		for (int i = 0; i<N;i++)
			std::cout<<pointVector[i]<<' '<<accValues[i]<<' '<<approxValues[i]<<'\n';
	}
	else  //если не главный процесс
	{
		// Получаем точность
		double eps;
		MPI_Bcast(&eps,1,MPI_DOUBLE,MPI_ROOT_PROCESS,MPI_COMM_WORLD);
		// Получаем количество точек
		int pointCount;
		MPI_Bcast(&pointCount,1,MPI_INT,MPI_ROOT_PROCESS,MPI_COMM_WORLD);
		
		if (pointCount>0)   // Пришло положительное, значит число точек для всех процессов одинаковое и мы его получили
		{
			double *points = new double[pointCount];
			// Получаем значения точек
			MPI_Scatter(0,0,MPI_DOUBLE,points,pointCount,MPI_DOUBLE,MPI_ROOT_PROCESS,MPI_COMM_WORLD);
			// Считаем функцию
			double *accValues = new double[pointCount];
			double *approxValues = new double[pointCount];
			for (int i = 0;i<pointCount;i++)
			{
				accValues[i]=GetFunctionValue(points[i]);
				approxValues[i] = GetApproxValue(points[i],eps);
			}
			
			// Отправляем точные значения
			MPI_Gather(accValues,pointCount,MPI_DOUBLE,0,0,MPI_DOUBLE,MPI_ROOT_PROCESS,MPI_COMM_WORLD);
			// Отправляем приближённые значения
			MPI_Gather(approxValues,pointCount,MPI_DOUBLE,0,0,MPI_DOUBLE,MPI_ROOT_PROCESS,MPI_COMM_WORLD);
		}
		else  // Если пришло отрицательное значение, значит число точек будет получено через scatter
		{
			// Получаем количество точек
			MPI_Scatter(0,0,MPI_DOUBLE,&pointCount,1,MPI_INT,MPI_ROOT_PROCESS,MPI_COMM_WORLD);
			// Получаем значения точек
			double *points = new double[pointCount];
			MPI_Scatterv(0,0,0,MPI_DOUBLE,points,pointCount,MPI_DOUBLE,MPI_ROOT_PROCESS,MPI_COMM_WORLD);

			// Считаем функцию
			double *accValues = new double[pointCount];
			double *approxValues = new double[pointCount];
			for (int i = 0;i<pointCount;i++)
			{
				accValues[i]=GetFunctionValue(points[i]);
				approxValues[i] = GetApproxValue(points[i],eps);
			}
			
			// Отправляем точные значения
			MPI_Gatherv(accValues,pointCount,MPI_DOUBLE,0,0,0,MPI_DOUBLE,MPI_ROOT_PROCESS,MPI_COMM_WORLD);
			// Отправляем приближенные значения
			MPI_Gatherv(approxValues,pointCount,MPI_DOUBLE,0,0,0,MPI_DOUBLE,MPI_ROOT_PROCESS,MPI_COMM_WORLD);
		}
	}
	MPI_Finalize();
	return 0;
}

