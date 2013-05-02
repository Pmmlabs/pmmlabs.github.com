program Task1;
{Проверить, является ли заданное дерево идеально сбалансированным}
{$APPTYPE CONSOLE}

uses
  SysUtils, Windows;
Type
  TInfo = integer;
  pTree = ^Ttree;
  Ttree = record
            info : TInfo;
            left, right : pTree;
          end;

var  mas:array[1..15] of integer=(5,4,1,3,2,7,9,6,8,11,18,16,12,14,19);
     TreeRandom,TreeUser,Treemas:pTree;
     i, j, n, probel, kol, node, znachenie, count, krand, p: integer;
     flag: Boolean;

Procedure CreateTree(var t : pTree; k: integer);    // Создание дерева пользователем или из массива
begin
if t= nil then
  begin
  new(t);
  t^.info:=k;
  t^.left:=nil;
  t^.right:=nil;
  end
else
  begin
  if k<=t^.info then CreateTree(t^.left, k)
  else if k>t^.info then CreateTree(t^.right,k);
  end;
end;

{Procedure CreateTreeRandom(var t1:pTree; cnt: integer);       // Рандомное создание дерева
begin
  if t1 = nil then
    begin
    new(t1);
    t1^.info:=cnt;
    t1^.left:=nil;
    t1^.right:=nil;
    end
  else
    begin
    if krand<t1^.info then CreateTreeRandom(t1^.left, cnt)
    else if krand>t1^.info then CreateTreeRandom(t1^.right, cnt);
    end;
end; }



Procedure PrintTree(t2 : pTree; l : integer);         // Печать  дерева
var s : string; i,m : integer;
begin
  m:=l;
  if t2 <> nil then
    begin
    PrintTree(t2^.right, l + 2);
    s:=' ';
    For i := 1 to l do s := s + ' ';
    s := s + IntToStr(t2^.info);
    Writeln(s);
    PrintTree(t2^.left, l + 2);
    end;
  end;

Function Proverka(t3 : pTree; var kolelem : integer) : Boolean;     //  Проверка на сбалансированность
var flL , flR : Boolean;
    kolL , kolR : integer;
begin
  kolelem:=0; kolL:=0 ; kolR:=0;
  if t3 = nil then
    begin
    Result:=true;
    kolelem:=0;
    end
  else
    begin
    flL:=Proverka(t3^.left, kolL);
    flR:=Proverka(t3^.right, kolR);
    Result:=flL and flR and (abs(kolL-kolR)<=1);
    kolelem := kolL+kolR+1;
    end;
end;


begin
  { TODO -oUser -cConsole Main : Insert code here }
  SetConsoleCP(1251); SetConsoleOutputCP(1251);
Repeat
i:=0; j:=0; n:=0; probel:=2; kol:=0;
node:=0; znachenie:=0; count:=0; krand:=0; p:=0;
Writeln;
randomize;
Writeln(' ========================Меню========================');
Writeln(' Выберите один из следующих пунктов: ');
Writeln('1. Создание дерева с помощью функции Randomize');
Writeln('2. Создание дерева с помощью ввода значений с клавиатуры ');
Writeln('3. Использование заданного дерева ');
Writeln('0. Выход ');
Write('--->');
Readln(j);
Case j of
  1: begin
     TreeRandom:=nil;
     Writeln(' Введите количество элементов будущего дерева');
     Readln(count);
     p:=1;
     While p<=count do
       begin
       krand := random(25)-5;
       CreateTree(TreeRandom, krand);
       inc(p);
       end;
     Repeat
       Writeln('1. Просмотр дерева ');
       Writeln('2. Проверка дерева на идеальную сбалансированность');
       Writeln('9. Возврат в главное меню');
       Write('---> ');
       Readln(j);
       Case j of
       1: PrintTree(TreeRandom,probel);
       2: begin
          Flag:= Proverka(TreeRandom, kol);
          Writeln(flag,' количество узлов в дереве: ', kol);
          end;
       end;
     Until j=9;
     end;
  2: begin
     TreeUser:=nil;
     Writeln(' Введите количество узлов будущего дерева');
     Write('--->');
     Readln(node);
     For i:=1 to node do
       begin
       Write('--->');
       Readln(znachenie);
       Writeln;
       CreateTree(TreeUser, znachenie);
       end;
     Repeat
     Writeln('1. Просмотр дерева ');
     Writeln('2. Проверка дерева на идеальную сбалансированность');
     Writeln('9. Возврат в главное меню');
     Write('---> ');
     Readln(n);
     Case n of
     1: PrintTree(TreeUser,probel);
     2: begin
        Flag:= Proverka(TreeUser, kol);
        Writeln(flag,' количество узлов в дереве: ', kol);
        end;
     end;
     Until n=9;
     end;
  3: begin
     Treemas:=nil;
     For i:=1 to 15 do
       CreateTree(Treemas, mas[i]);

     Repeat
     Writeln('1. Просмотр дерева ');
     Writeln('2. Проверка дерева на идеальную сбалансированность');
     Writeln('9. Возврат в главное меню');
     Write('---> ');
     Readln(j);
     probel:=2;
     Case j of
     1: PrintTree(Treemas,probel);
     2: begin
        Flag:= Proverka(Treemas, kol);
        Writeln(flag,' количество узлов в дереве: ', kol);
        end;
     end;
     Until j=9;
     end;
  0: Exit;
end;
Until false;
end.



