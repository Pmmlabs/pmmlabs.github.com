program Maxotr;

{$APPTYPE CONSOLE}

uses
  Windows,SysUtils;
var
   m,i,n,k:integer;

Begin
  { TODO -oUser -cConsole Main : Insert code here }
  setconsolecp(1251);
  setconsoleoutputcp(1251);
m:=0;
writeln('Введите последовательность чисел:');
readln(n);
for i:=1 to n do
   begin
     readln(k);
     if (k<0) and ((k>m) or (m=0)) then
     m:=k;
   end;
writeln('Наибольшее отрицательное:',m);
readln
End.
