#include "stdafx.h"
#include <mpi.h>
#include <list>
#include <random>
#include <iostream>
#include <string>
using namespace std;


// Размерность массива
const int n = 10;


//находим максимальный отрицательный
void FindMax(int *in, int *max, int *len, MPI_Datatype *datatypes)
{
	for (int i=0; i<*len; i++)
	{
			if (max[i] >= 0)
				if (in[i] < 0)
					max[i] = in[i];
				else
					max[i] = 0;
			else
				if ((in[i] < 0) && (in[i] > max[i]))
					max[i] = in[i];
	}
}



int _tmain(int argc, char* argv[])
{
	// Инициализация MPI
	MPI_Init(&argc,&argv);

	int processCount = 0;
	MPI_Comm_size(MPI_COMM_WORLD,&processCount);

	if (processCount>1)
	{
		int *arr = new int[n];
		srand((unsigned int)arr);

		int rank = 0;
		MPI_Comm_rank(MPI_COMM_WORLD, &rank);

		string str = "Process " + to_string(rank) + " generated elements: ";

		// Заполнение массива и его вывод на экран.
		for (int i=0; i<n; i++)
		{
			arr[i]=-100+ rand()%300;
			str+= to_string(arr[i]) + " ";
		}
		printf("%s\n",str.c_str());

		//инициализируем нашу операцию для редукции
		MPI_Op operation;
		MPI_Op_create((MPI_User_function*)FindMax,0,&operation);
		int *max = new int[n];
		MPI_Reduce(arr,max,n,MPI_INT,operation,0,MPI_COMM_WORLD);

		if (rank==0)
		{
			string resultString = "Result: ";
			for ( int j = 0; j < n; j++)
				resultString += to_string(max[j]) + " ";
			printf("%s\n",resultString.c_str());
		}
	}

	MPI_Finalize();
	return 0;
}


