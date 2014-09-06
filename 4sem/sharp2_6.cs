using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


//1/sqrt(1-x^2)=1+1/2 * x^2 + (1*3)/(2*4) * x^4 + (1*3*5)/(2*4*6) * x^6 + ...
namespace ConsoleApplication1
{
    class Program
    {
        static void Main(string[] args)
        {
            float x0, xn, eps, h;
            string str;
            // Ввод х0 
            do
            {
                Console.Write("Введите x0: ");
                str = Console.ReadLine();
                try
                {
                    x0 = float.Parse(str);
                }
                catch (FormatException exc)
                {
                    Console.WriteLine(exc.Message);
                    x0 = 0;
                }
                catch (OverflowException exc)
                {
                    Console.WriteLine(exc.Message);
                    x0 = 0;
                }
            } while (x0 <= -1 || x0 >= 1);

            // Ввод хn 
            do
            {
                Console.Write("Введите Хn: ");
                str = Console.ReadLine();
                try
                {
                    xn = float.Parse(str);
                }
                catch (FormatException exc)
                {
                    Console.WriteLine(exc.Message);
                    xn = 0;
                }
                catch (OverflowException exc)
                {
                    Console.WriteLine(exc.Message);
                    xn = 0;
                }
            } while (xn < -1 || xn > 1);

            //Ввод h
            Console.Write("Введите h: ");
            str = Console.ReadLine();
            try
            {
                h = float.Parse(str);
            }
            catch (FormatException exc)
            {
                Console.WriteLine(exc.Message);
                h = 0;
            }
            catch (OverflowException exc)
            {
                Console.WriteLine(exc.Message);
                h = 0;
            }
             
            // Ввод эписилон
            do
            {
            Console.Write("Введите eps: ");
            str = Console.ReadLine();
            try
            {
                eps = float.Parse(str);
            }
            catch (FormatException exc)
            {
                Console.WriteLine(exc.Message);
                eps = 0;
            }
            catch (OverflowException exc)
            {
                Console.WriteLine(exc.Message);
                eps = 0;
            }
            } 
            while (eps < 0 || eps >= 1);

            int k, MaxK;
            MaxK = 7;
            float Xcur = x0; // Текущее значение Х
            while (x0 <= xn)
            {
                k = 1;
                // Вывод строки с иксами
                Console.Write("\n\nx:               ");
                while ((Xcur <= xn) && (k < MaxK))
                {
                    Console.Write("{0:f5}\t", Xcur);
                    Xcur += h;
                    k++;
                };
                k = 1;

                //Вывод строки со значениями, посчитанными через функцию
                Console.Write("\nf(x) вычисл:     ");
                Xcur = x0;
                while ((Xcur <= xn) && (k < MaxK))
                {
                    Console.Write("{0:f5}\t", 1/Math.Sqrt(1-Xcur*Xcur));
                    Xcur += h;
                    k++;
                };

                //Вывод строки со значениями, посчитанными по формуле
                k = 1;
                Console.Write("\nf(x) по формуле: ");
                Xcur = x0;
                while ((Xcur <= xn) && (k < MaxK))
                { // вычисление значения при текущем Х
                    float sum = 0;  // сумма слагаемых
                    int i = 0; // номер слагаемого
                    float slag = 1;
                    float sqrXcur = Xcur * Xcur; // квадрат текущего икса
                    while (Math.Abs(slag) >= eps)   // пока слагаемое по модулю больше е
                    {
                        i++; // увеличение номера слагаемого
                        sum += slag;  // прибавление слагаемого к сумме                
                        slag = slag * sqrXcur * (2 * i - 1) / (2 * i); //вычисление следующего слагаемого
                    };
                    Console.Write("{0:f5}\t", sum);
                    Xcur += h;
                    k++;
                };
                x0 = Xcur;
            };
            Console.ReadLine();
       }
    }
}
