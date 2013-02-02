program str167n4;

{$APPTYPE CONSOLE}

uses
  SysUtils,windows;

Type TListA=^TA;
     TlistB=^TB;
     TA= record
     FIO,P: string;
     Next: TListA;
   End;
   TB=record
     Pr:string;
     Next: TListB;
   end;
var headA,tailA,t1,p:TlistA;
    headB,tailB,t2:TlistB;
    str,str2:string;
    i:integer;
    yn:char;
    OK:boolean;
//-----------Процедуры для списка А----------
procedure AddFirstA(var h:TlistA;el1,el2:string);
var z:TlistA;
begin
 new(z);
 z^.FIO:=el1;
 z^.P:=el2;
 z^.Next:=h;
 h:=z;
end;
procedure AddAfterA(var h:TlistA;el1,el2:string);
var z:TlistA;
begin
 new(z);
 z^.FIO:=el1;
 z^.P:=el2;
 z^.Next:=h^.next;
 h^.Next:=z;
end;
procedure printA(h:TlistA);
begin
 if h<>nil then
  begin
   writeln(h^.FIO,' - ',h^.p);
   printA(h^.Next);
  end;
end;
procedure DeleteFirst(var p:TlistA);
var z:TlistA;
begin
 new(z);
 z:=p;
 p:=z^.Next;
 dispose(z);
end;
//-----------Процедуры для списка B----------
procedure AddFirstB(var h:TlistB;el:string);
var z:TlistB;
begin
 new(z);
 z^.Pr:=el;
 z^.Next:=h;
 h:=z;
end;
procedure AddAfterB(var h:TlistB;el:string);
var z:TlistB;
begin
 new(z);
 z^.Pr:=el;
 z^.Next:=h^.next;
 h^.Next:=z;
end;
procedure printB(h:TlistB);
begin
 if h<>nil then
  begin
   writeln(h^.Pr,' ');
   printB(h^.Next);
  end;
end;
//-----------MAIN-------------------
Begin
 SetConsoleCP(1251);                  // Установка кодировки Кириллица 1251
 SetConsoleOutputCP(1251);
 // Ввод списка А
 i:=1;
 writeln('Ввод списка А:');
 headA:=nil;
 write('Введите ФИО ',i,': ');
 readln(str);
 write('Введите профессию ',i,': ');
 readln(str2);
 AddFirstA(heada,str,str2);
 tailA:=headA;
 write('Желаете продолжать? (Y/N): ');
 repeat readln(yn);
 until yn in ['y','Y','n','N'];
 while yn in ['Y','y'] do
  begin
    inc(i);
    write('Введите ФИО ',i,': ');
    readln(str);
    write('Введите профессию ',i,': ');
    readln(str2);
    AddAfterA(tailA,str,str2);
    tailA:=tailA^.next;
    write('Желаете продолжать? (Y/N): ');
    repeat readln(yn);
    until yn in ['y','Y','n','N'];
  end;
 // Ввод списка В
 i:=1;
 writeln('Ввод списка B:');
 headB:=nil;
 write('Введите профессию ',i,': ');
 readln(str);
 AddFirstB(headB,str);
 tailB:=headB;
 write('Желаете продолжать? (Y/N): ');
 repeat readln(yn);
 until yn in ['y','Y','n','N'];
 while yn in ['Y','y'] do
  begin
    inc(i);
    write('Введите профессию ',i,': ');
    readln(str);
    AddAfterB(tailB,str);
    tailB:=tailB^.next;
    write('Желаете продолжать? (Y/N): ');
    repeat readln(yn);
    until yn in ['y','Y','n','N'];
  end;
writeln('----До:----');
writeln('Список А:');
printA(headA);
writeln('-----------');
writeln('Список B:');
printB(headB);
writeln('---После:---');
t1:=headA;
while t1<>nil do
 begin
  t2:=headB;
  OK:=false;
  while (t2<>nil) and (not OK) do
   begin
    ok:=t1^.P=t2^.Pr;
    if (not ok) then t2:=t2^.Next;
   end;
  if not OK then
   if t1=headA then
    begin
     DeleteFirst(t1);
     headA:=t1;
    end
   else
    begin
     DeleteFirst(t1);
     p^.next:=t1;
    end
  else
   begin
    p:=t1;
    t1:=t1^.Next;
   end;
 end;
writeln('Список А:');
printA(headA);
writeln('-----------');
writeln('Список B:');
printB(headB);
writeln('-----------');
readln;
end.
