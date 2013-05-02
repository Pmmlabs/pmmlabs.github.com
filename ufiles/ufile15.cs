using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Interval
{
    class Program
    {/*Дан массив, задающий множество интервалов на числовой прямой. Определить,
      можно ли их объединить в один интервал.*/
        static void Main(string[] args)
        {
            
            string buf;
            int size;
            Console.WriteLine("Введите количество интервалов");
            buf = Console.ReadLine();
            try
            {
                size = (int.Parse(buf)*2);
                size = size>0 ? size : -size;
            }
            catch (FormatException exc)
            {
                Console.WriteLine(exc.Message);
                size = 2;
            };
            Console.WriteLine("Количество интервалов="+size/2);
            float[] mass = new float[size];
            for (int i = 0; i < size; i++)
            {
                bool flag = false;
                while (!flag)
                {
                    flag = false;
                    Console.Write("Введите "+(i%2+1)+" координату "+(i/2+1)+" точки:");
                    buf = Console.ReadLine();
                    try
                    {
                        mass[i] = float.Parse(buf);
                        if (i % 2 != 0)
                        {
                            if (mass[i]>mass[i-1])
                            {
                                flag = true;
                            }
                        }
                        else
                            flag = true;
                    }
                    catch (FormatException exc)
                    {
                        Console.WriteLine(exc.Message);
                        flag = false;
                    }
                }
            };
            float[] interval = new float[2];
            bool[] added = new bool[size / 2];
            for (int i = 0; i < size / 2; i++)
            {
                added[i] = false;
            }
            interval[0] = mass[0];
            interval[1] = mass[1];
            added[0] = true;
            int add = 0;
            int quan = 1;
            do
            {
                add = 0;
                for (int i = 0; i < size; i += 2)
                {
                    if (added[i/2]==false)
                        if ((mass[i] <= interval[0] && mass[i+1]>=interval[0]) || (mass[i + 1] >= interval[1] && mass[i]<=interval[1]) || (mass[i]>=interval[0] && mass[i+1]<=interval[1]))
                        {
                            interval[0] = mass[i] < interval[0] ? mass[i] : interval[0];
                            interval[1] = mass[i + 1] > interval[1] ? mass[i + 1] : interval[1];
                            added[i / 2] = true;
                            add++;
                            quan++;
                        }
                }
            } while ((add != 0) && (quan != size/2));
            if (quan == size / 2)
            {
                Console.WriteLine("Да, возможно");
                Console.WriteLine(interval[0]+", "+interval[1]);
            }
            else
            {
                Console.WriteLine("Нет, невозможно");
            }
        }
    }
}
