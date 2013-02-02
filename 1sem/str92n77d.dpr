program str92n77d;
{$APPTYPE CONSOLE}
uses
  SysUtils,
  windows;
const m=30;
const n=10;
var i,j:integer;
    c:char;
    a:array[1..m,1..n] of char;
    fl,error_n:boolean;
begin
SetConsoleCP(1251);
SetConsoleOutputCP(1251);
for i:=1 to m do
 for j:=1 to n do
 a[i,j]:=' ';
 j:=1; i:=0; c := '1';  error_n := false;
 writeln('Введите от 2-х до ',m,' слов длинною не более 10 символов. В конце поставьте точку.');
 while c <> '.' do
  begin
   inc(i);
   read(c);
   while c = ' ' do read(c);
   while (c <> ' ') and (c <> '.') do
    begin
     a[i,j] := c;
     read(c);
     inc(j);
    end;
   if j = 2 then error_n := true;
   j := 1;
  end;
 if error_n then writeln('Ошибка!!! Присутствуют слова, длина которых меньше 2');
 if i = 1 then writeln ('Ошибка!!! Количество слов меньше 2');
readln;
if error_n or (i = 1) then writeln('Имеются ошибки. Перезапустите программу и введите корректные данные')
else
for i:=2 to m do
 begin
  fl:=true;
  j := 1;
  while ((a[i,j] <> ' ')and (a[i,1]<>' ')) and fl do
   begin
    if a[i,j] <> a[1,j] then fl := false;
    inc(j);
   end;
    if (a[i,j] <> ' ')or (a[1,j]<>' ') then fl := false;
  j := 1;
  if not fl then
   begin
    while a[i,j+1] <> ' ' do inc(j);
    for j:=j to n-1 do a[i,j]:=a[i,j+1];
    for j:=1 to n do write(a[i,j]);
    writeln;
   end;
 end;
readln;
end.
