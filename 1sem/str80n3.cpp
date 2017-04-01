//Пусть даны вещественные числа а1,а2,...,a2n. Эти точки определяют n интервалов числовой оси(a1,a2),(a3,a4),...,(a2n-1,a2n).
//Имеются ли точки числовой оси, принадлежащие по крайней мере трем каким-нибудь из данных интервалов? Если да, то вывести любую из этих точек;
//Выполнила Савостикова Ольга, 61 группа;
#include "iostream"
#include "windows.h"

using namespace std;

int main()
{
	SetConsoleCP(1251);
	SetConsoleOutputCP(1251);

	unsigned int n;
	cout << "Введите количество интервалов:\n";
	cin >> n;														

	float*x = new float[n];	//Начало интервала;										
	float*y = new float[n];	//Конец интервала;										

	for (int i = 0; i < n; i++)				
	{
		cout << "Введите " << i+1 << " интервал:\n"; //Ввод интервалов;				
		cin >> x[i] >> y[i];
	}

	float a, b, c;
	for (int i = 0; i < n - 1; i++)	//Сортируем интервалы по возрастанию их начальных точек;								
	{
		if (x[i + 1] < x[i])
		{
			a = x[i + 1];
			b = y[i + 1];
		
			x[i + 1] = x[i];
			y[i + 1] = y[i];
		
			x[i] = a;
			y[i] = b;
		
		}
	}

	int minY, maxX, E4 = 0, err = 0; //Конец и начало отрезка общих точек, сообщение об ошибке;								
	for (int i = 0; i < n - 2; i++)
	{
		if (x[i + 1] < y[i])
		{
			if (y[i] < y[i + 1]) minY = y[i]; //Находим отрезок общих точек;						
			else minY = y[i + 1];

			if (x[i + 2] < y[i + 1]) maxX = x[i + 2];
			if (y[i + 2] < minY) minY = y[i + 2];
		}
		else E4++;

		if (E4 == 0)												
		{
			cout << "Есть общая точка: " << (minY + maxX) / 2 + 0.0001<< endl; //Выводим общие точки;
		}
		else
		{
			E4 = 0;
			err++;
		}
	}

	if (err == n-2) cout << "Нет общих точек\n";					
	system("pause");
    return 0;
}

