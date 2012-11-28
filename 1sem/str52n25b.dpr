program str52n25b;
{При некоторых заданных x, N и Е, определяемых вводом, вычислите сумму N слагаемых заданного вида,
 а также сумму тех слагаемых, которые по абсолютной величине больше Е. Для второго случая выполните 
суммирование для двух значений Е, отличающихся на порядок, и при этом определите количество слагаемых, 
включенных в сумму. Сравните результаты с точным значением функции, для которой данная сумма определяет 
приближенное значение при х, лежащем в интервале (-R, R)
b) e^-x^2}
{$APPTYPE CONSOLE}

uses
SysUtils,
windows;

var fakt,summa,summa_e,summa_e10,x ,e,x_v_stepeni:real;
i,n,mon,kol_vo_e,kol_vo_e10: integer;
begin
SetConsoleCP(1251); 
SetConsoleOutputCP(1251); 
summa:=1; fakt:=1; summa_e:=1; summa_e10:=1; mon:=1; i:=0;
repeat
 writeln('введите x,N,E');
 readln(x,n,e);
until n>=1;
//------
x_v_stepeni:=1;
while abs(mon*x_v_stepeni/fakt)>e do
   begin
    inc(i);
    fakt:=fakt*i;
    mon:=-mon;
    x_v_stepeni:=x_v_stepeni*sqr(x);
    summa_e:=summa_e+(mon*x_v_stepeni/fakt);
   end;
summa_e10:=summa_e;
kol_vo_e:=i;
  while abs(mon*x_v_stepeni/fakt)>e/10 do
   begin
    inc(i);
    fakt:=fakt*i;
    mon:=-mon;
    x_v_stepeni:=x_v_stepeni*sqr(x);
    summa_e10:=summa_e10+(mon*x_v_stepeni/fakt);
   end;
kol_vo_e10:=i;

  i:=0; fakt:=1; mon:=1; x_v_stepeni:=1; summa:=1;
  for i:=1 to n do
   begin
    fakt:=fakt*i;
    mon:=-mon;
    x_v_stepeni:=x_v_stepeni*sqr(x);
    summa:=summa+(mon*x_v_stepeni/fakt);
   end;

writeln('точное значение функции = ',exp(-sqr(x)):5:5);
writeln('сумма элементов, больших е, = ',summa_e:5:5,' , этих элементов ',kol_vo_e,' штук');
writeln('сумма элементов, больших е/10, = ',summa_e10:5:5,' , этих элементов ',kol_vo_e10,' штук');
writeln('Сумма ',n,' слагаемых = ',summa:5:5);
readln;
end.