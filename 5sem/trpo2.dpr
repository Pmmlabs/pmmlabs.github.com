program trpo2;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  windows;

type TState = (start,ident,int,rel,finish);
     TChar = (letter,digit,Point,any,fin);
var T: array[TState,TChar] of TState = ((ident, int,   start, start, finish),
                                        (ident, ident, start, start, finish),
                                        (ident, int,   rel,   start, finish),
                                        (ident, rel,   start, start, finish),
                                        (finish,finish,finish,finish,finish));
    StateNames: array[TState] of string = ('Начало','идентификатор','целое','вещественное','конец');
    pred,cur:TState;
    c:TChar;
    ch:Char;
    letters: set of char = ['q','w','e','r','t','y','u','i','o','p','a','s','d','f','g','h','j','k','l','z','x','c','v','b','n','m'];
    digits: set of char = ['0' .. '9'];
    lexema:string;
    {ao:set of char = ['+','-','*','/'];
    sravn: set of char = ['<','>','='];
    brakes: set of char = ['(',')','[',']'];
    special: array[1..n] of string = ('if','else','then','and','or','while','repeat','do','until');   }
begin
  SetConsoleOutputCP(1251);
  Writeln('Введите строку:');
  cur:=start;
  lexema:='';
  repeat
   repeat
    read(ch);
    if ch in letters then c:=letter
    else if ch in digits then c:=digit
    else if ch = '.' then c:=Point
    else if (ch = #13) or (ch=#10) then c:=fin
    else c:=any;
    pred:=cur;
    cur:=T[pred,c];
    lexema:=lexema+ch;
   until ((cur<>pred) and (cur<>Rel) ) or (cur=finish);
   Writeln(Copy(lexema,1,Length(lexema)-1)+' - '+StateNames[pred]);
   lexema:=ch;
  until ch=#13;
  if cur <> Start then  Writeln(lexema+' - '+StateNames[cur]);
  Readln;
  Readln;
end.
