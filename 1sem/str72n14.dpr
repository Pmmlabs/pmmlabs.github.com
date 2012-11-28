program Project1;
{Пусть вводится последовательность символов, длина которой не превышает 80. 
Напечатайте те русские буквы (в алфавитном порядке), которые встречаются в заданной последовательности.}
{$APPTYPE CONSOLE}

uses
  SysUtils,
  windows;

const n = 10;
var c:char;
    i,k:integer;
    a:array['А'..'Я'] of boolean;
    fl,r,yo:boolean;
    w:array[0..32] of char = ('а','б','в','г','д','е','ё','ж','з','и','й','к','л','м','н','о','п','р','с','т','у','ф','х','ц','ч','ш','щ','ъ','ы','ь','э','ю','я');
begin
 fl:=true; i:=0; yo:=false;
 SetConsoleCP(1251);
 SetConsoleOutputCP(1251);
 for c := 'А' to 'Я' do a[c] := false;
 writeln('Введите последовательность символов:');
  while (i<>n) and (not eoln) do
  begin
   r:=false;
   inc(i);
   read(c);
   for k:=0 to 32 do if (c=w[k]) or (c=chr(ord(w[k])-(ord('а')-ord('А')))) then r:=true;
   if r then
   begin
    if c >= 'а' then c:=chr(ord(c)-(ord('а')-ord('А')));
    a[c] := true;
    if (c='ё') or (c='Ё') then yo:=true;
   end;
  end;
  read(c);
  if c<>#13 then writeln('Длина строки больше ',n,' символов, в пределах ',n,' символов результат такой:');
  readln;
 writeln('Русские буквы, содержащиеся в строке:');
 for c:='А' to 'Я' do if a[c]then
  begin
  write(c:2);
  fl:=false;
  end;
 if yo then writeln('Ё':2);
 if fl=true then writeln('таких нет');
 readln;
end.
