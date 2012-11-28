program TpeyroJIbHuK;
{$APPTYPE CONSOLE}
uses
  SysUtils,
  Windows;

var x1,x2,x3,y1,y2,y3,a,b,c:Real;
begin
SetConsoleCP(1251);
SetConsoleOutputCP(1251);
Writeln('Введите координаты вершин:');
  Read(x1,y1);Writeln; read(x2,y2);Writeln; read(x3,y3);Writeln; //ввод координат
     a:=sqr(x1-x2)+sqr(y1-y2);    // сторона A
     b:=sqr(x1-x3)+sqr(y1-y3);    // сторона B
     c:=sqr(x3-x2)+sqr(y3-y2);   // сторона С
     if (Sqrt(a)+sqrt(b)<=sqrt(c))or(Sqrt(a)+sqrt(c)<=Sqrt(b))or(Sqrt(b)+sqrt(c)<=sqrt(a)) then  write('Не существует') else
  begin
     if (a=b+c)or(b=a+c)or(c=b+a) then write('Прямоугольный ') else
     if (a>c+b)or(b>a+c)or(c>a+b) then write('Тупоугольный ') else write('Остроугольный ');
     if (a<>b)and(a<>c)and(b<>c) then write('разностороний') else
     if (a=b)and(a=c)and(b=c) then write('равностороний') else
     write('равнобедреный');
   end;
  readln;Readln;
end.
