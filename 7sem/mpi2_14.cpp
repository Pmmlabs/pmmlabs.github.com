#include "stdio.h"
#include "mpi.h"
#include "conio.h"
#include "stdlib.h"
#include "math.h"
#include "windows.h"
#include <locale.h>
#pragma setlocale("rus_rus.1251")

double calculate (double , double);

int main(int arg0, char * arg1[]) {
	calculate(1,4);
	int size,  //Количество процессов
		rank,  //Ранг процесса
		count; //Количество точек, которые должен обработать каждый процесс
	double 
		eps,           //Точность
		
		*sendbufdots,  //Все точки из интервала [A,B] с шагом (B - A) / (n-1)
		
		*recbufdots,   //Точки, принятые процессом для вычисления суммы ряда
		*sendbuf,      //Вычисленная сумма ряда в этих точках
*		recvbuf;       //Вычисленная сумма ряда во всех точках

	
	MPI_Init(&arg0, &arg1);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);

	if (rank == 0) { //Процессор - мастер

		//Вводим необходимые данные
		printf("Please, Input A, B, eps, n \n");
		flushall();

		double A, B;
		int n;
		scanf("%lf%lf%lf%d", &A, &B, &eps, &n);
		printf("%.2f %.2f %.2f %d \n",A, B, eps, n);
		flushall();

		//Вычислить все точки
		sendbufdots = (double *) malloc(n*sizeof(double)); //Массив точек
		recbufdots = (double *) malloc(n*sizeof(double));
		double step = (B - A) / (n-1); //Шаг
		A -= step;
		for (int i=0; i < n; i++)
			sendbufdots[i] = (A += step);		

		//count = ceil(double(n) / double(size) );
		count = n / size;
		sendbuf = (double *) malloc(count*sizeof(double));
		recvbuf = (double *) malloc(count*size*sizeof(double));

		//Отправляем всем процессам количество значений, которые они должны будут принять обработать ///
		MPI_Bcast(&count, 1, MPI_INT, 0, MPI_COMM_WORLD); 

		//Отправляем значения
		MPI_Scatter(sendbufdots, count,MPI_DOUBLE, recbufdots, count, MPI_DOUBLE, 0, MPI_COMM_WORLD);

			
		
		//Отправляем eps
		MPI_Bcast(&eps, 1, MPI_DOUBLE, 0, MPI_COMM_WORLD);

		//Вычисляем значения
		for (int i = 0 ; i < count; i ++)
			sendbuf[i] = calculate(recbufdots[i], eps);

		//Отправляем значения и одновременно получаем их
		MPI_Gather (sendbuf, count, MPI_DOUBLE, recvbuf, count, MPI_DOUBLE, 0, MPI_COMM_WORLD);
		
		//Выводим полученные результаты на экран
		SetConsoleOutputCP(1251);
		printf("Dot           Exact value    Found value");
		for (int i = 0 ; i < count*size; i++) {
			printf("\n%-15.3f ", sendbufdots[i]);
			printf("%-15.3f ", log(1 + sendbufdots[i]));
			printf("%-15.3f ", recvbuf[i]);
		}

		//Т.к Количество точек не всегда кратно количеству процессов, то некоторые процессы будут выполнять большее количество вычислений.
		//Пусть первый процесс выполняет оставшиеся вычисления	
		//Оставшиеся точки
		for (int i = count*size ; i < n; i++) {
			printf("\n%-15.3f ", sendbufdots[i]);
			printf("%-15.3f ", log(1 + sendbufdots[i]));
			printf("%-15.3f ", calculate(sendbufdots[i], eps));
		}
		flushall();

	}
	else {
		//Принимаем количество значений, которые процесс должен будет обработать
		MPI_Bcast(&count, 1, MPI_INT, 0, MPI_COMM_WORLD);

		sendbufdots = (double *) malloc(count*sizeof(double));
		recbufdots  = (double *) malloc(count*sizeof(double));
		recvbuf     = (double *) malloc(count*sizeof(double));

		//Принимаем значения
		MPI_Scatter(sendbufdots, count,MPI_DOUBLE, recbufdots, count, MPI_DOUBLE, 0, MPI_COMM_WORLD );

		//Принимаем eps
		MPI_Bcast(&eps, 1, MPI_DOUBLE, 0, MPI_COMM_WORLD);

		//Вычисляем значения
		sendbuf = (double *) malloc(count*sizeof(double));
		for (int i = 0 ; i < count; i ++)
			sendbuf[i] = calculate(recbufdots[i], eps);
		
		//Отправляем значения
		MPI_Gather (sendbuf, count, MPI_DOUBLE, recvbuf, count, MPI_DOUBLE, 0, MPI_COMM_WORLD);
	}
	MPI_Finalize();
	return 0;
}

//Определить значение функции в точке х с точностью eps
double calculate (double x, double eps) {
	double
		powX =  - x * x,
		pred = x,
		result = pred - x * x / 2 ;
	
	for (int pos = 3; fabs (pred - result) > eps ; pos ++  ) {
		powX *= -x;
		pred = result;
		result +=  powX / pos ;
	}
	return result;
}