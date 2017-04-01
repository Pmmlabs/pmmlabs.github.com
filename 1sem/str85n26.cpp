//����� ���� ������������ ���������� ������� ������� n. ��������� ������������������ ������������ ����� a1...an �� �������:
//���� � i-� ������ ������� �������, ������������� ������� ���������, �����������, �� ������� ai ����� ����� ������������� 
//��������� i-� ������, � ��������� ������ ai ����� ������������ ������������� ��������� i-� ������.
//��������� ����������� �����, 61 ������.
#include "iostream"
#include "windows.h"

using namespace std;

int main()
{
	SetConsoleCP(1251);
	SetConsoleOutputCP(1251);
	
	int n;
	cout << "������� ������ �������:\n"; // ���� ������� �������
	cin >> n;
			
	float*matrix = new float[n]; // ��������� ������ ��� ������ �������
	float*a = new float[n];	// ��������� ������ ��� ��������� ������������������

	int error = 0;	// ������� ������
	float S = 0, P = 1;	// ����� ������������� � ������������ ������������� ���������
	for (int i = 0; i < n; i++)
	{
		cout << "������� " << i + 1; // ���� ������
		if (i + 1 == 3) cout << "-�� ������:\n";
		else cout << "-�� ������:\n";
		for (int j = 0; j < n; j++)
		{
			cin >> matrix[j]; // ���������� 2 ��������� �������� ������������������
			if (matrix[j] > 0) 
				S += matrix[j];
			else P*= matrix[j];
			if (matrix[j] == -1) error++; // ��������� ��������, ��� ���� ����������� ������ ����� ��������� ������ -1
		}
		if (matrix[i] > 0)	// ����������� 1-�� �� 2-� �������� � ������� ������������������ 
		{
			if (P == 1 && error % 2 == 0) a[i] = 0;	// ���� �� ����������� ������ ����� ��������� -1, �� ������������ ����� 0
			else a[i] = P;
		}													
		else a[i] = S;
		
		S = 0;	// ����� ���������
		P = 1;
	}
	cout << "�������� ������������������:\n"; // ����� ������������������
	for (int i = 0; i < n; i++) cout << a[i] << endl;

	system("pause");
    return 0;
}

