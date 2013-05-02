//написать подпрограмму,определ€ющую есть ли в списке хот€ бы два одинаковых элемента(ƒинамические структуры данных)
#include <iostream>
using namespace std;

struct list
{
     int d;
     list *next;
};

list *create(list **end, const int a); //создание элемента списка
void search(list *end, list *l); //поиск

int main() 
{
    int a, n;
    cout<<" "<<"IMPUT N: ";
    cin>>n;
    cout<<"\n";
    cin>>a;
    list *l = new list;
    list *end=l;
    int d;
    l->d=a; //присваивает а переменной d, наход€щейс€ в записи, адрес которой содержитс€ в указателе l.
    for (int i=1; i<n; i++)
    {
        cin>>a;
        end=create(&end, a);
    }
    search(end, l);
    cout <<"\n";
    system("pause");
return 0;
}

list *create(list **end, const int a) //** чтобы значение указател€ мен€лось
{
     int d;
     list *l = new list;
     l->d=a; //занесли элемент
     l->next=0; //следующего нет
     (*end)->next=l; //в предыдущем указатель на текущую
     *end = l; //указатель на конец
     return (*end);
}

void search(list *end, list *l)
{
     list *head=l; // указатель на первый элемент
     list * f = l;
     list * h = l;
     bool r = false;
     while ((l)&&(r==false))
     {
           
           while ((f)&&(r==false)) //пока не конец списка
           {        
              if ((l->d==f->d)&&(f!=l)) //поиск одинаковых
                    r = true;
              f = f->next; //шаг цикла
           }
           l = l->next;
           f = h;
           
     }
     if (r == true)
     cout<<"est' odinakowie";
     else
     cout<<"net odinakowih";
}