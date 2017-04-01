// Laba2.cpp: определяет точку входа для консольного приложения.
//

#include "stdafx.h"
#include <iostream>; 
using namespace std; 

int laba2(int **massiv, int n, int odd = 0, int even = 0) 

{ 
	for (int i = 0; i < n; i++)
	{ 
		for (int j = 0; j < n; j++)
		{ 
			if (even == 0)
			{ 
				if ((massiv[i][j] % 2) == 0) 
					even++; 
			} 
		}
		if (even == 0) odd++;
		cout << "\n"; 
	} 
	return odd;
} 

void main() 
{ 
	int n, x; 

	cout << "Please enter the number of rows ";
	cin >> n;

	int **massiv = new int *[n];
	
	for (int i = 0; i < n; i++) 
	    { 
		massiv[i] = new int[n];
	    }

	for (int i = 0; i < n; i++) 
	    { 
		for (int j = 0; j < n; j++)
		    { 
			cin >> massiv[i][j]; 
		    }
		cout << "\n"; 
	    } 

	cout << "\n" << "Enter x  "; 
	cin >> x; 

	if (!laba2(massiv, n) == 0)
	{
		if (laba2(massiv, n)%x == 0)
		 cout << "Yes, multiples"; 
	}
    else cout << "Not multiply"; 

	for (int i = 0; i < n; i++) 
		delete[] massiv[i]; 
	delete[] massiv;

	cin.get(); 
	cin.get();
}





