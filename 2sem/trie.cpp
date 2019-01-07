// В trie-дереве найти слово с наименьшей длиной.

#include <iostream>
#include <string>

using namespace std;

string m = "qwertyuiopasdfghjklzxcvbnm";
const int N = 26; //число английских букв в алфавите

struct Node {
	Node *ptrs[N]; //массив из указателей
	bool eow; //признак конца слова
};

void Init_Tree(Node*&t) {
	t = NULL;
}

bool Empty_Tree(Node* t) {
	return t == NULL;
}

void Add_Word(Node *&t, string w, unsigned int i) {
	if (t == NULL) {
		t = new Node;
		t->eow = false;
		for (int c = 0; c < N; c++) {
			t->ptrs[c] = NULL;//всем указателям в массиве присваиваем нули
		}
	}
	if (w.length() - 1 < i)//все буквы в слове размещены
		t->eow = true;//устанавливаем признак конца слова
	else
		Add_Word(t->ptrs[w[i] - 'a'], w, i + 1); //переходим к ссылке из буквы i
}

void Print_Word(Node * t, string w) { //передаем пустую строку и указатель на дерево
	if (t == NULL) return;
	if (t->eow == true) { //если конец слова
		cout << w << endl;
		for (int c = 0; c<N; c++)
			if (t->ptrs[c] != NULL) {
				Print_Word(t->ptrs[c], w + char(c + 'a'));
			}
	}
	else {
		for (int c = 0; c<N; c++)
			if (t->ptrs[c] != NULL) { //если указатель не пуст
				Print_Word(t->ptrs[c], w + char(c + 'a'));//входим в рекурсию и к строке прибавляем букву соответствующую номеру указателя в массиве ссылок
			}
	}
}

void Search_Min_Word(Node * t, string w) {
	if (t->eow == true) {
		if (w.length()<m.length()) {
			m = w;
		}
		for (int c = 0; c<N; c++)
			if (t->ptrs[c] != NULL)
			{
				Search_Min_Word(t->ptrs[c], w + char(c + 'a'));
			}

	}
	else
	{
		for (int c = 0; c<N; c++)
			if (t->ptrs[c] != NULL) //если указатель не пуст
			{
				Search_Min_Word(t->ptrs[c], w + char(c + 'a'));
			}
	}
}

int main() {
	setlocale(LC_ALL, "Rus");
	Node *t;
	Init_Tree(t);
	string w = "";
	int n;
	cout<<"Enter n=";
	cin>>n;
	while (n>0) {
		cin>>w;
		Add_Word(t, w, 0);
		n--;
	}
	if (Empty_Tree(t)) {

		cout << "Tree пусто\n";
	}
	else {
		string ques;
		cout<<"Показать tree?(y/n)"; cin>>ques;
		if (ques == "y") {
			cout << "Tree:"<<endl;
			Print_Word(t, "");
		}
	}
	Search_Min_Word(t, "");
	cout<<"Слово с наименшой длиной: "<<m;
	return 0;
}