program str47n49d;
{ѕусть вводитс€ последовательность из целых чисел, оканчивающа€с€ нулем. 
Ќайдите номер меньшего из двух наибольших чисел последовательности}
{$APPTYPE CONSOLE}

uses
  SysUtils,
  windows;

var a,i,max1,max2,maxi1,maxi2:integer;
begin
SetConsoleCP(1251);
SetConsoleOutputCP(1251);
a:=1; i:=0; max1:=-65535; max2:=-65535;
writeln('¬ведите последовательность целых чисел, оканчивающуюс€ нулем');
readln(a);
while a<>0 do
begin
 inc(i);
 if a>max2 then
              begin
               maxi1:=maxi2;
               max1:=max2;
               max2:=a;
               maxi2:=i;
              end
 else
 if a>max1 then
              begin
               max1:=a;
               maxi1:=i;
              end;
 readln(a);
 end;
writeln('Ќомер меньшего из двух наибольших чисел последовательности = ',maxi1);
readln;
end.
 