program trpo1;

{$APPTYPE CONSOLE}

uses
  SysUtils,windows;
const n=9;
var i:integer;
    s,current:string;
    ch:char;
    letters: set of char = ['q','w','e','r','t','y','u','i','o','p','a','s','d','f','g','h','j','k','l','z','x','c','v','b','n','m'];
    digits: set of char = ['1','2','3','4','5','6','7','8','9','0'];// ['0'..]
    ao:set of char = ['+','-','*','/'];
    sravn: set of char = ['<','>','='];
    brakes: set of char = ['(',')','[',']'];
    special: array[1..n] of string = ('if','else','then','and','or','while','repeat','do','until');
function isspecial(const s:string):boolean;
var i:integer;
begin
 i:=1;
 result:=false;
 while (i<=n) and (not result) do
  begin
   result:=s=special[i];
   inc(i);
  end;
end;
begin
 SetConsoleOutputCP(1251);
 i:=1;
 s:='';
 read(ch);
 repeat
  // нач
  current:='';
   if ch in letters then
    //ид-р
    begin
     current:=current+ch;
     read(ch);
     while ch in (digits + letters) do
      begin
       current:=current+ch;
       read(ch);
      end;
      if isspecial(current) then s:=s+'зарезервированноеслово '
       else s:=s+'идентификатор ';
      current:='';
    end
   else if ch in digits then
   // целое
   begin
    read(ch);
    while ch in digits do  read(ch);
    if ch='.' then
    //вещ
     begin
      read(ch);
      while ch in digits do  read(ch);
      s:=s+'вещественное ';
     end
    else s:=s+'целое ';
   end
   else if ch ='.' then
    begin
     s:=s+'точка ';
     read(ch);
    end
   else if ch=':' then
    begin
     read(ch);
     if ch='=' then
      begin
       s:=s+'присваивание ';
       read(ch);
      end
     else s:='двоеточие '
    end
   else if ch in ao then
   // АО
    begin
     s:=s+'AO ';
     read(ch);
    end
   else if ch in brakes then
   // АО
    begin
     s:=s+'скобка ';
     read(ch);
    end
   else if ch in sravn then
    begin
     read(ch);
     if ch='=' then read(ch);
     s:=s+'сравнение ';
    end
   else if ch=' ' then read(ch)
  until (ch=#13) or (ch=#10);
  writeln(s);
  readln;
  readln
end.
