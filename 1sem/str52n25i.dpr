program Project2;
{При некоторых заданных x, N и Е, определяемых вводом, вычислите сумму N слагаемых
 заданного вида, а также сумму тех слагаемых, которые по абсолютной величине больше Е. 
Для второго случая выполните суммирование для двух значений Е, отличающихся на порядок,
 и при этом определите количество слагаемых, включенных в сумму. Сравните результаты с 
точным значением функции, для которой данная сумма определяет приближенное значение при х,
 лежащем в интервале (-R, R). 1/(1+x)^3=1-(2*3*x)/2+(3*4*x^2)/2-(4*5*x^3)/2+... (R=1).
}
{$APPTYPE CONSOLE}
uses
  SysUtils,
  Windows;

var x,eps,sum,a:Real;
    i,n:Integer;
begin
  SetConsoleCP(1251);
  SetConsoleOutputCP(1251);
  repeat
    write('Введите N>0: ');readln(N);
  until N>0;
  repeat
  write('Введите x (-1<x<1): ');Readln(x);
  until (x>-1)and(x<1);
  repeat
  write('Введите eps->0: ');Readln(eps);
  until eps<1;
  sum:=1; a:=1;
  for i:=2 to N do
  begin
    a:=-a*x*((i+1)/(i-1));                //сумма эл-ов N
    sum:=sum+a;
  end;
  writeln('Сумма ',N,' элементов =',sum:8:5);

  sum:=0; a:=1; N:=2;                    //сумма эл-ов больших eps
  while Abs(a)>eps do
    begin
      sum:=sum+a;
      a:=-a*x*((n+1)/(n-1));
      N:=N+1;
    end;
  writeln('Сумма эл-ов больших eps =',sum:8:5,' N=',N-2);

  eps:=eps/10;
   while Abs(a)>eps do
    begin                                        //сумма эл-ов больше eps/10
      sum:=sum+a;
      a:=-a*x*((n+1)/(n-1));
      N:=N+1;
    end;
  writeln('Сумма эл-ов больших eps/10 =',sum:8:5,' N=',N-1);
  Writeln('1/(1+x)^3=',1/(sqr(1+x)*(1+x)):8:5);
  readln;Readln;
end.
