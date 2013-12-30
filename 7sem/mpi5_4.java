import java.io.IOException;

import mpi.*;
public class Test {
	static final int NUM_DIMS = 1;
	static final int[] dims;
	static final boolean[] periods;	
	
	static {
		dims = new int[NUM_DIMS];
		periods = new boolean[NUM_DIMS];
		for (int i = 0; i<NUM_DIMS; i++) {
			dims[i] = 0;
			periods[i] = true;
		}
	}
		
	public static void main(String[] args) throws IOException {		
		MPI.Init(args);

		int size = MPI.COMM_WORLD.Size();
		int rank = MPI.COMM_WORLD.Rank();
			
		//Определяем размер одномерной решетки <=> dims = {size}
		Cartcomm.Dims_create(size, dims);
				
		//Определяем новую топологию
		Cartcomm cart_comm = MPI.COMM_WORLD.Create_cart(dims,periods, false);
		
		//Определяем соседей
		ShiftParms source_dest = cart_comm.Shift(0, -1);
		
		int[] a = new int[size];
		int[] b = new int[size];
		for (int i = 0; i < size; i++) {
			a[i] =  (int) (Math.random() * 10);
			b[i] =  (int) (Math.random() * 10);		
		}
		
		//Нулевой процесс выводит сгенерированные матрицы
		int[] recvbufA = new int[size * size];
		int[] recvbufB = new int[size * size];
		cart_comm.Gather(a, 0, size, MPI.INT, recvbufA, 0, size, MPI.INT, 0);
		cart_comm.Gather(b, 0, size, MPI.INT, recvbufB, 0, size, MPI.INT, 0);
		if (rank == 0) {
			System.out.println("Матрица А: ");			
			for (int i = 0; i < size; i++) {
				int sumstr = 0;
				for (int j = 0; j < size; j++) {
					System.out.format("%4d", recvbufA[size * i + j]);
					sumstr += recvbufA[size * i + j];
				}
				System.out.print("  |"+ sumstr +"\n");
				
			}
			
			int [] sumColumn = new int [size];
			for (int i  = 0; i < size ; i++)
				sumColumn[i] = 0;			
			System.out.println("Матрица B: ");
			for (int i = 0; i < size; i++) {
				for (int j = 0; j < size; j++) {
					System.out.format("%4d", recvbufB[size * j + i]);
					sumColumn[j] += recvbufB[size * j + i];
				}
				System.out.print("\n");
			}
			
			for (int i  = 0; i < size ; i++)
				System.out.format("%4d", sumColumn[i]);
		}
		//Нулевой процесс вывел матрицы
		
		int index = rank; //Индекс строки матрицы B, которая в данный момент находится в массиве b
		
		int min = 0;
		for (int j = 0; j < size ; j ++) {
			min += (b[j] + a[j]); 				
		}
		cart_comm.Sendrecv_replace(b, 0 , size, MPI.INT, source_dest.rank_dest, 0, source_dest.rank_source, 0);
		
		for (int i = 0; i < size; i++) {
			
			if (++index == size)
				index = 0;
			int rescur = 0;
			for (int j = 0; j < size ; j ++) {
				rescur += (b[j] + a[j]); 				
			}
			if (rescur < min)
				min = rescur;
			cart_comm.Sendrecv_replace(b, 0 , size, MPI.INT, source_dest.rank_dest, 0, source_dest.rank_source, 0);
			
		}

		int[] minbuf = {min};
		
		cart_comm.Gather(minbuf, 0, 1, MPI.INT, recvbufA, 0, 1, MPI.INT, 0);
		if (rank == 0) {
			
			System.out.print(" \n");
			for (int i =0; i<size; i++) {
				System.out.printf("%4d\n", recvbufA[i]);
			}
		}
		
		MPI.Finalize();
	}
	
}