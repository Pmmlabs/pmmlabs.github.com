program str105n17;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  windows;
const n=4;
Type  str=array[1..n] of integer;
      massiv=array[1..n] of str;

function f(var stroka:str):boolean;
var i,k:integer;
    sum1,sum2:integer;
begin
 f:=false;
 k:=2; 
 repeat
  sum1:=0;sum2:=0;
  for i:=1 to k-1 do sum1:=sum1+stroka[i];
  for i:=k+1 to n do sum2:=sum2+stroka[i];
  if sum1=sum2 then f:=true;
  k:=k+1;
 until (sum1=sum2) or (k>=n);
end;

procedure create_matr (var m:massiv);
 var i,j:integer;
 begin
  for i:=1 to n do
  for j:=1 to n do
  //m[i][j]:=random(10);
  read(m[i][j]);
  readln;
 end;

procedure write_matr (var m:massiv);
var i,j:integer;
begin
for i:=1 to n do
  begin
    for j:=1 to n do
    write(m[i,j]:4);
    writeln;
  end;
end;
var a:massiv;
    v:array[1..n] of boolean;
    stolbec:str;
    i,j:integer;
begin
SetConsoleCP(1251);
SetConsoleOutputCP(1251);
writeln('Введите элементы матрицы размером ',n,'x',n);
create_matr(a);
writeln('Матрица A:');
write_matr(a);
writeln('Результаты по строкам:');
for i:=1 to n do
   begin
    v[i]:=f(a[i]);
    write(v[i],' ');
   end;
writeln;
writeln('Результаты по столбцам:');
for j:=1 to n do
 begin
  for i:=1 to n do
  stolbec[i]:=a[i,j];
  v[j]:=f(stolbec);
  write(v[j],' ');
 end;
readln;
end.
