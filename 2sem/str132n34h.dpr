program str132n34h;
{$APPTYPE CONSOLE}
uses SysUtils,windows;
const maxn = 100;
type                                     // Условие задачи
  Stroka = array [1..20] of char;
  Week = (pn,vt,sr,cht,pt,sb,vs);
  Time = record
         hours: 0..23;
         minutes: 0..59;
         end;
  Seminar = record
            predmet,prepod: stroka;
            day: week;
            h: record
               start, finish: Time;
               end;
            group: 1..300;
            auditoria: integer;
            end;                         //---------------
var
  a: array[1..maxn] of seminar;          // Массив сведений о занятиях
  i,n,j,m,count,p:integer;
  yn:char;
  s:array[1..maxn] of string;            // Массив названий предметов
procedure readstr(var str: stroka);      // Чтение типа Stroka
var c:char;
    k:integer;
begin
 k:=1;
 while (not eoln) and (k<=20) do
  begin
   read(c);
   str[k]:=c;
   inc(k);
  end;
 readln;
end;                                    //--------------------
procedure inputtime(var t:time);        // Ввод типа Time
var k:integer;
begin
 repeat
  write('часы: ');
  read(k);
 until k in [0..23];
 t.hours:=k;
 repeat
  write(' минуты: ');
  read(k);
 until k in [0..59];
 t.minutes:=k;
 readln;
end;                                    //---------------
procedure inputseminar(var s:seminar);  // Ввод типа Seminar
var k:integer;
begin
 with s do
 begin
  write('Введите предмет: '); readstr(predmet);
  write('Введите преподавателя: '); readstr(prepod);
  repeat
   write('Введите номер дня недели (от 1 до 7): ');
   readln(k);
   until k in [1..7];
  s.day:=week(k-1);
  write('Введите начало семинара: '); inputtime(h.start);
  write('Введите конец семинара: '); inputtime(h.finish);
  write('Введите номер группы: '); readln(group);
  write('Введите аудиторию: '); readln(auditoria);
 end;
end;                                    //------------------
begin                                   // Главная программа
SetConsoleCP(1251);                     // Установка Кириллицы
SetConsoleOutputCP(1251);
 i:=1;
 repeat                                 // Ввод массива сведений о занятиях
  writeln('Введите информацию о семинаре номер ',i,' :');
  inputseminar(a[i]);
  write('Для прекращения ввода нажмите S, для продолжения любую другую букву:');
  readln(yn);
  inc(i);
 until yn in ['s','S','ы','Ы'];        // условие завершения до достижения maxn
 writeln('Количество занятий:');
 n:=1; dec(i);
 while n<=i do                          // Заполнение массива строк названиями предметов
  begin
   for m:=1 to 20 do if a[n].predmet[m]<> #0 then s[n]:=s[n]+a[n].predmet[m];
   inc(n);
  end;
 n:=1;                                //------------------
 while n<=i do                        // Для каждого вновь встретившегося предмета
  begin
   count:=1;                          // гарантируемое количество вхождений - 1
   write(s[n],' - ');                 // печатаем название этого предмета
   j:=n+1;
   while j<=i do if s[n]=s[j] then    // проходим по строкам до конца массива
    begin                             // в поисках этого же предмета
     inc(count);                      // если находим - увеличиваем счетчик
     for p:=j to i-1 do s[p]:=s[p+1]; // и удаляем этот найденный элемент, чтобы заново на него не наткнуться.
     dec(i);                          // уменьшаем "длину" массива
    end
   else inc(j);                       // если не находим - то просто продолжаем поиск
   writeln(count,' занятий');         // вывод количества для текущего предмета.
   inc(n);                            // переходим к следующему предмету
  end;
readln;
end.
 