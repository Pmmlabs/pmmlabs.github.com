import mpi.*;

public class test {
	static int N = 10; // Размер массива

	public static void main(String[] args) {

		MPI.Init(args);
		int rank = MPI.COMM_WORLD.Rank();
		// Кол-во процессов
		int processCount = MPI.COMM_WORLD.Size();

		if (processCount > 1) {

			// Создание и заполнение массива
			int[] array = new int[N];
			for (int i = 0; i < N; i++)
				array[i] = (int) (Math.random() * 10) - 5; // [-5,5]

			// Пусть нулевой процесс выводит вектора
			int[] recvbuf = new int[N * processCount];
			MPI.COMM_WORLD.Gather(array, 0, N, MPI.INT, recvbuf, 0, N, MPI.INT, 0);
			if (rank == 0) {
				for (int i = 0; i < processCount; i++) {
					System.out.print("Процесс " + i + " \t: ");
					for (int j = 0; j < N; j++)
						System.out.format("%4d", recvbuf[N * i + j]);
					System.out.print("\n");
				}
			}

			Operation uf = new Operation();

			int[] max = new int[N];
			MPI.COMM_WORLD.Reduce(array, 0, max, 0, N, MPI.INT, new Op(uf, false), 0);
			
			if (rank == 0) {
				System.out.print("Итоговый\t: ");
				for (int j = 0; j < N; j++)
					System.out.format("%4d",max[j]);
			}
		}
		MPI.Finalize();
	}
}

class Operation extends User_function {
	static boolean first = true;

	@Override
	public void Call(Object arg0, int arg1, Object arg2, int arg3, int arg4,
			Datatype arg5) {
		try {
			int[] in = (int[]) arg0;
			int[] res = (int[]) arg2;
			if (first) { //Первый раз вошли в эту функцию
				for (int i = 0; i < arg4; i++) {
					if (res[i] <= 0)
						res[i] = 1;
				}
				first = false;
			}
			for (int i = 0; i < arg4; i++) {
				if (in[i] > 0) {
					res[i] *= in[i];
				}
			}
		} catch (MPIException e) {
			e.printStackTrace();
		}
	}
}