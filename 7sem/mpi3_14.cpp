// mpi32.cpp: определяет точку входа для консольного приложения.
//

#include "stdafx.h"
#include <mpi.h>
#include <list>
#include <random>
#include <iostream>
#include <string>

using namespace std;


// Размерность массива
const int n = 4;
static bool first = true;
//void FindMax(int *, int *, int *, MPI_Datatype *);
void FindMax(int *in, int *max, int *len, MPI_Datatype *datatypes)
{
	if (first)
	{
		for (int i = 0; i < *len; i++)
		{
			if (max[i] == 0)
				max[i] = 1;
			else max[i] = 0;
		}
		first = false;
	}
		for (int i = 0; i < *len; i++)
			if (in[i] == 0)

				max[i]++;
	

}
//найти минимально число фиб превосх макс знач: 0 если нет положзит

int _tmain(int argc, char* argv[])
{
	// Инициализация MPI
	MPI_Init(&argc, &argv);
	// Кол-во процессов
	int processCount = 0;
	MPI_Comm_size(MPI_COMM_WORLD, &processCount);

	if (processCount>=1)
	{
		int *array = new int[n];
		srand((unsigned int)array);

		int rank = 0;
		MPI_Comm_rank(MPI_COMM_WORLD, &rank);

		string str = "Process " + to_string(rank) + " generated elements: ";
		// Заполнение массива и его вывод на экран.
		for (int i = 0; i<n; i++)
		{
			// Генерируем число и записываем в массив.
			array[i] = rand() % 4;
			// Выводим данное число
			str += to_string(array[i]) + " ";
		}
		printf("%s\n", str.c_str());
		int *max = new int[n];
		for (int i = 0; i < n; i++)
		{
			max[i] = 0;
		}
		MPI_Op operation;
		MPI_Op_create((MPI_User_function *)FindMax, true, &operation);
		MPI_Reduce(array, max, n, MPI_INT, operation, 0, MPI_COMM_WORLD);
		MPI_Op_free(&operation);
		if (rank == 0)
		{
			string resultString = "Result: ";
			for (int j = 0; j < n; j++)
				resultString += to_string(max[j]) + " ";
			printf("%s\n", resultString.c_str());
		}
	}

	MPI_Finalize();
	return 0;
}

