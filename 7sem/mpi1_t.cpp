// MPI_first_task.cpp: определяет точку входа для консольного приложения.
//

#include "stdafx.h"
#include "mpi.h"
#include <stdlib.h>

#define ARRAY_TAG 1

const int m = 10;

//checks if <Array> has <element> in first <asz> elements
bool Contains(int *Array, int asz, int element)
{
	int i = 0;
	while (i<asz && Array[i] != element)
		i++;
	return i<asz;
}

//fills the array <x> with <size> elements
void GetArray (int *x, int asz, int seed)
{
	srand(seed);
	const int maxValue = 20;
	for (int i = 0; i<asz; i++)
	{
		int t = rand() % maxValue;
		while (Contains(x,i,t))
		{
			t = (t+1)%maxValue;
		}
		x[i] = t;
	}
}


int _tmain(int argc, char* argv[])
{
	//initialize MPI
	MPI_Init(&argc, &argv);

	int rank = 0;
	//Get rank of current process
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	
	//initialize and fill set
	int *procVector = new int[m];
	GetArray(procVector,m, (unsigned int)(&procVector));

	//if process if main
	if (rank == 0)
	{
		printf("Process 0 generated elements: ");
			for (int i = 0; i<m;i++)
				printf("%d ",procVector[i]);
			printf("\n");
		//maximum count of intersected elements is m
		int *result = new int[m];
		//current intersected elements is m
		int intersected = m;
		//initialize a receive data buffer
		int *buffer = new int[m];
		int processCount;
		//Get count of process	
		MPI_Comm_size(MPI_COMM_WORLD, &processCount);
		//wait for data from other process
		for (int i = 1; i<processCount; i++)
		{
			//put m elements in buffer from any source and any tag using comm. In current task receive status also doesn't matter. 
			MPI_Recv(buffer,m,MPI_INT,MPI_ANY_SOURCE,ARRAY_TAG,MPI_COMM_WORLD,0);
			printf("Process 0 received elements: ");
			for (int i = 0; i<m;i++)
				printf("%d ",buffer[i]);
			printf("\n");
			if (intersected>0)
			{
				int curIntersected = 0;
				for (int j = 0; j<m; j++)
				{					
					if (Contains(procVector,intersected,buffer[j]))
					{
						result[curIntersected]= buffer[j];
						curIntersected++;
					}
				}
				int *tmp = procVector;
				procVector=result;
				result=tmp;
				intersected = curIntersected;
				printf("Current intersection: ");
				for (int i = 0; i<intersected;i++)
					printf("%d ",procVector[i]);
				printf("\n");
			}
		}
		printf("Intersected elements:\n");
		for (int i = 0; i<intersected;i++)
			printf("%d ",procVector[i]);
	}
	else
	{
		MPI_Send(procVector,m,MPI_INT,0,ARRAY_TAG, MPI_COMM_WORLD);
	}
	MPI_Finalize();
	return 0;
}

