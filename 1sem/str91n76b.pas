program str91n76b;
const m=50;
const n=9;
var i,j,p,k:integer;
    c:char;
    a:array[1..m] of array[1..n] of char;
    fl,psp:boolean;
begin
for i:=1 to m do
 for j:=1 to n do
 a[i,j]:=' ';
 j:=1; i:=0; c := '1';
 writeln('Введите от 2-х до ',m,' слов длиною не более 8 символов. В конце поставьте точку.');
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
   j := 1;
   k:=i;
  end;
 if i = 1 then writeln ('Количество слов меньше 2!')
 else begin
for i:=1 to k-1 do
 begin
  fl:=true;
  j := 1;
  while ((a[i,j] <> ' ')and (a[k,j]<>' ')) and fl do
   begin
    if a[i,j] <> a[k,j] then fl := false;
    inc(j);
   end;
    if (a[i,j] <> ' ')or (a[k,j]<>' ') then fl := false;
  j := 1;
  if not fl then
   begin
    while a[i,j+1] <> ' ' do inc(j); 
    p:=j; psp:=false;
    for j:=2 to p do
     if a[i,j]=a[i,1] then psp:=true;
     if psp then
    for j:=1 to p do 
      write(a[i,j]);
    writeln;
   end;
 end;
readln;
end;
end.
