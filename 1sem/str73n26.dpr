program str73n26;
{$APPTYPE CONSOLE}
uses
  SysUtils,
  windows;

const n=10;
var a:array[1..n] of integer;
i,max,min,c,n1:integer;
begin
SetConsoleCP(1251);
SetConsoleOutputCP(1251);
writeln('Введите ',n,' целых чисел');
for i:=1 to n do read(a[i]);
max:=a[1]; min:=a[1];
readln;
for i:=2 to n do
 begin
  if a[i]>max then max:=a[i];
  if a[i]<min then min:=a[i];
 end;
 i:=1;
 n1:=n;
 while i<=n1 do
 begin
  if (a[i]=max) or (a[i]=min) then
  begin
   for c:=i to n1-1 do a[c]:=a[c+1];
   dec(n1);
   dec(i);
  end;
 inc(i);
 end;
 if n1=0 then writeln('Массив остался пуст') else
 for i:=1 to n1 do write(a[i]:3);
 readln;
end.
 