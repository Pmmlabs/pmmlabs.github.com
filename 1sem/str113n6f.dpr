program str113n6f;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  windows;
var a,b,a1,m:real;
ind,n:integer;
function stepen(x,n:real):real;
var i:integer;
begin
result:=x;
 for i:=2 to trunc(n) do result:=result*x;
end;
function Integral(a,b:real;n:integer):real;
var x:real;
begin
inc(ind);
x:=a+(b-a)/(n-1)+ind ;
  if n=1 then result:=(x*stepen(a1,m*x)/m*ln(a1)) - (stepen(a1,m*x)/m*sqr(ln(a1)))
  else result:=stepen(x,n)*stepen(a1,m*x)/m*ln(a1) - n*integral(a,b,n-1)/m*ln(a1);

end;
begin
 ind:=1;
 SetConsoleCP(1251);
 SetConsoleOutputCP(1251);
 write('Введите Границы интегрирования a,b: ');
 readln(a,b);
 write('Введите параметры a,n,m: ');
 readln(a1,n,m);
 writeln('Ответ: ',integral(a,b,n));
 readln;
end.
