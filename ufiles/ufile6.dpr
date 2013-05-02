program MaxMinDifference;

{$APPTYPE CONSOLE}

uses
  SysUtils, Windows;

var
  i:integer;
  x,max,min:real;
Begin
  { TODO -oUser -cConsole Main : Insert code here }
  SetConsoleCP(1251);
  SetConsoleoutputCP(1251);

//ввод чисел
writeln('Введите 10 чисел:');
readln(x);
min:=x;
max:=x;

//вычисление разности
  for i:=2  to 10   do
      begin
         read(x);
         if  x>max   then
             max:=x
         else
         if     x< min  then
             min:=x;
      end;

//печать результата
       writeln('Разность между максимальным и минимальным числами равна:', max-min:0:0);
       readln;

writeln('Для выхода из программы нажмите <Enter>');
readln
End.
