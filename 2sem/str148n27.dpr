program str148n27;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  windows;
const maxm=5;
var f:file of integer;
    fname: string;
    m,cur,pred,j,i:integer;
    OK: boolean;
begin
SetConsoleCP(1251);
SetConsoleOutputCP(1251);
OK:=true;
write('Введите имя файла: ');
readln(fname);
while fname = '' do
 begin
  write('Имя файла пусто! Повторите ввод: ');
  readln(fname);
 end;
while not fileexists(fname) do
 begin
  write('Такого файла нет! Повторите ввод: ');
  readln(fname);
 end;
assign(f,fname);
{
rewrite(f);
randomize();
for i:=1 to maxm do
begin
 for j:=1 to maxm do
 begin
  pred:=random(100);
  write(f,pred);
  write(pred:5);
 end;
 writeln;
end;
closefile(f);
reset(f);
}

reset(f);
for i:=1 to maxm do
begin
 for j:=1 to maxm do
 begin
  read(f,pred);
  write(pred:5);
 end;
 writeln;
end;
seek(f,0);

if eof(f) then writeln('Файл пуст!') else
 begin
  writeln('Файл ',fname,' открыт! Введите m: ');
  readln(m);
  while m>maxm do
   begin
    writeln('Значение m должно быть меньше ',maxm,'! Повторите ввод m:');
    readln(m);
   end;
  seek(m);
  read(f,pred);
  while not eof(f) and OK do
   begin
    for j:=1 to m do read(f,cur);
    OK:=cur>pred;
    pred:=cur;
   end;
  if OK then writeln('Значения ',m,'-го столбца упорядочены по возрастанию.') else
  writeln('Значения ',m,'-го столбца не упорядочены по возрастанию.');
 end;
closefile(f);
readln;
end.
 