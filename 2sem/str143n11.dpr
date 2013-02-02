program str143n11;
{$APPTYPE CONSOLE}
uses
  SysUtils,
  windows;
const n=4;
      max_value=30;
var a:array[1..n,1..n] of 0..max_value;
    max,min,i,j:integer;
    s,s2: set of 0..max_value;
begin
 SetConsoleCP(1251);
 SetConsoleOutputCP(1251);
 writeln('Введите матрицу ',n,' на ',n,':');
 for i:=1 to n do                     // Ввод матрицы
  begin                               //
   for j:=1 to n do read (a[i,j]);    //
   readln;                            //
  end;                                //
 writeln('Ответ:');
 for i:=1 to n do                      // Обработка массива
  begin
   max:=a[i,1]; min := a[i,1]; s:=[]; s2:=[];                           // инициализация переменных
   for j:=2 to n do
    if a[i,j]>max then max:=a[i,j] else if a[i,j]<min then min:=a[i,j]; // поиск минимума и максисума строки i
  s:=[min..max];// for j:=min to max do s:=s+[j];                           // формирование множества чисел, которые должны быть в строке
   for j:=1 to n do s2:=s2+[a[i,j]];                        // формирование множества чисел, которые находятся в строке
   if s=s2 then writeln(i);                                 // если эти множества равны, то условие задачи выполнено.
  end;
 readln;
end.
