using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace _5task1
{
    public class MyExcept : System.ArgumentException
    {
        public MyExcept(string arg)
        {
            Console.WriteLine(arg);
        }
    }

    public class ArrayQueue
    {
        private const int n = 10;
        private int head, tail, fcount;
        private int[] a = new int[n];
        public int Count                  // Свойство "Количество"
        {
            get
            {
                return fcount;
            }
        }
      /*  public int this[int index]      // Индексное свойство
        {
            get
            {
                if ((index >= head && index < tail) || (index >= head && tail < head) || (index < head && tail < head))
                    return a[index];
                else
                {
                    Console.WriteLine("Элемента с таким номером нет в очереди");
                    return -1;
                }
            }
            set
            {
                if ((index >= head && index < tail) || (index >= head && tail < head) || (index < head && tail < head))
                    a[index] = value;
                else
                {
                    Console.WriteLine("Невозможно изменить элемент с таким номером");
                }
            }
        }*/
        private void clearqueue()          // вспомогательная функция очистки очереди
        {
            head = 0;
            tail = 0;
            fcount = 0;
            a[0] = 0;
        }
        public ArrayQueue()             // конструктор
        {
            clearqueue();
        }
        public int Pop()
        {
            try
            {
                if (fcount > 0)
                {
                    int t = a[head];
                    head++;
                    fcount--;
                    if (head > n - 1) head = 0;
                    return t;
                }
                else
                {
                    throw new MyExcept("Очередь пуста");

                }
            }
            catch (_5task1.MyExcept)
            {
                return 0;
            }
        }
        public void Push()                   // Добавление элемента
        {
            try
            {
                if (fcount == n) throw new MyExcept("Извините, но больше места в очереди нет!");
                else
                {
                    Console.WriteLine("Введите элемент для добавления: ");
                    a[tail] = Convert.ToInt32(Console.ReadLine());
                    if (tail == n - 1) tail = 1;
                    else tail++;
                    fcount++;
                }
            }
            catch (_5task1.MyExcept)
            {
               
            }
        }
        public override string ToString()
        {
            string result="";
            if (fcount > 0)
            {
                if (tail > head)
                {
                    for (int i = head; i < tail; i++)
                        result+=" "+ Convert.ToString(a[i]);
                }
                else
                {
                    for (int i = head; i < n; i++)
                        result += " " + Convert.ToString(a[i]);
                    for (int j = 0; j < tail; j++)
                        result += " " + Convert.ToString(a[j]);
                    
                }
            }
            return result;
        }
        public void Print()
        {
            if (fcount>0) Console.WriteLine("Очередь: "+ToString());
            else Console.WriteLine("Очредь пуста");
        }
        public void Clear()             // Очистка очереди
        {
            clearqueue();
        }
    }
    class Program
    {
        static void Main(string[] args)
        {
            ArrayQueue Arr = new ArrayQueue();
            char choise;
            do
            {
                Console.WriteLine("Меню:\n1.Добавить.\n2.Очистить\n3.Достать элемент\n4.Напечатать количество\n5.Печать очереди\n0.Выход.\n");
                choise = Convert.ToChar(Console.ReadLine());
                switch (choise)
                {
                    case '1':
                        Arr.Push();
                        break;
                    case '2':
                        Arr.Clear();
                        break;
                    case '3': Console.WriteLine("Элемент: {0}", Arr.Pop());
                        break;
                    case '4': Console.WriteLine(Arr.Count);
                        break;
                    case '5': Arr.Print();
                        break;
                    case '0': break;
                    default: Console.WriteLine("\nНеверный ввод, введите число от 0 до 4\n");
                        break;
                }
            } while (choise != '0');
        }
    }
}
