uses crt;
var x,e,xN,s:real;
    i,n: integer;
begin
   repeat
    write('введите |x|<1 x=');
    read(x);
  until abs(x)<1;
  write('e= ');
  read(e);
  write('количество слагаемых n = ');
  read(n);
s:=0; xN:=-1;
for i:=1 to n do
  begin
        xN:=-xN*x;
       s:=s+xN/i;
 end;
writeln('При n = ',n,' сумма = ',s:0:4, ' ,сравнение = ', abs(s-(ln(1+x))):2:10);
writeln('==============================================================================');
xN:=x; i:=1;
while abs(xN/i)>e do
   begin
         i:=i+1;
       xN:=-xN*x;
    s:=s+xN/i;
 end;
writeln('При ',e:1:10,' сумма = ',s,' количество слагаемых = ',i, ' ,сравнение = ', abs(s-(ln(1+x))):2:10);
writeln('===============================================================================');
e:=e/10;
while abs(xN/i)>e do
 begin
       i:=i+1;
     xN:=-xN*x;
  s:=s+xN/i;
 end; 
writeln('При  ',e:1:10,' сумма = ',s,' количество слагаемых = ',i,' ,сравнение = ', abs(s-(ln(1+x))):2:10);
end.