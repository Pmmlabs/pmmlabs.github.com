import mpi.*;

public class test {
	static final int N = 11; // Размерность Матрицы

	public static void main(String[] args) {

		mpi.MPI.Init(args);
		//Создаем исходный массив размером N*N и выводим его в виде матрицы
		System.out.println("Сгенерированная матрица размерности "+ N +" :\n");
		int [] a = new int[N*N];
		for (int i = 0; i < N ; i ++) {
			for (int j = 0; j < N; j++) {
				System.out.printf("%4d", a[i*N+j] = (int) (Math.random() * 100) ); //[0;100]
			}
			System.out.println("\n");
		}

		//Размерность вектора b = 3*N - 3
		int [] b = new int[3*N-3];
		
		// Создаем массив длин блоков и массив смещения  всего будет 2*(N-1) блоков
		int[] array_of_blocklengths  = new int[2*(N-1)];
		int[] array_of_displacements = new int[2*(N-1)];

		array_of_blocklengths [0] = N;
		array_of_displacements[0] = 0;
		int row = 1;
		for(int i=2; i < 2*(N-1) ; i+= 2, row++){
			array_of_blocklengths [i-1] =1;
			array_of_displacements[i-1] = N*(row);

			array_of_blocklengths [i] =1;
			array_of_displacements[i] = (N - 1)*(row+1);
		}
		array_of_blocklengths [2*(N-1) - 1] =1;
		array_of_displacements[2*(N-1) - 1] = N*(N-1); 		
		///

		//Создание типа и его регистрация
		Datatype matrixtype = Datatype.Indexed(array_of_blocklengths, array_of_displacements, MPI.INT);	
		matrixtype.Commit();
		//
		
		//Преобразование матрицы в элемент типа matrixtype
		int rank = MPI.COMM_WORLD.Rank();
		int tag = 0;
		MPI.COMM_WORLD.Sendrecv( a, 0, 1, matrixtype, rank, tag, b, 0, 3*N - 3, MPI.INT, rank, tag);
		
		//Вывод верхней треугольной матрицы на экран
		ShowUpTriangleMatrix(b);
		
		MPI.Finalize();
	}
	
	//Вывод верхней треугольной матрицы на экран
	static public void ShowUpTriangleMatrix(int[] b) {
		System.out.println(" \n");
		
		//Выводим первые N элементов на первой строке
		for (int i = 0; i < N ; i ++)
			 System.out.printf("%4d", b[i]);
		System.out.println();
		
		//В каждой из последующих строк будет 2 пропуска.
		//Первый - длиной disp1 элементов. От первого видимого элемента строки, до последующего
		//Второй - длиной disp2 элементов. От второго видимого элемента строки, до конца строки
		//При переходе к след строке disp1 уменьшается на 1, disp2 - увеличивается
		int 
			disp1 = N - 3,
			disp2 = 1;		
		for (int i = N; i< b.length-1; i += 2) {
			System.out.format("%4d", b[i]); //Выводим первый элемент строки
			for (int j = 0; j < disp1; j++) {
				System.out.format("    "); //Пропускаем
			}
			disp1--;
			
			System.out.format("%4d", b[i+1]); //Выводим первый элемент строки
			for (int j = 0; j < disp2; j++) {
				System.out.format("    "); //Пропускаем
			}
			System.out.println();
			disp2++;
		}
		//Выводим последний элеиент матрицы
		System.out.format("%4d\n", b[b.length-1]);
	}
}
