program str45n34c;
{Пусть дано натуральное число n и вещественные числа a1, a2,...,an, которые вводятся по одному. Получите a1+2a2+...nan}
{$APPTYPE CONSOLE}

uses
  SysUtils,windows;

var s,i,a,n:integer;
begin
SetConsoleCP(1251);
SetConsoleOutputCP(1251);
 repeat
  writeln('Введите натуральное число n');
  readln(n);
  until (n>0);
  for i:=1 to n do
  begin
  readln(a);
  s:=s+i*a;
  end;
  writeln('Сумма =',s);
  readln;
end.
 