program Summa;

{$APPTYPE CONSOLE}

uses
  Windows,SysUtils;

var S, x, Pr : Real;
    n, i : Integer;
Begin
{ TODO -oUser -cConsole Main : Insert code here }
setconsolecp(1251);
setconsoleoutputcp(1251);
  Write('¬ведите число слагаемых:'); ReadLn(n);
  Write('¬ведите x:'); Readln(x);
  Pr := 1;
  S := 0;
    For i := 1 To n Do
     begin
      Pr := Pr * Sin(x);  {ќчередна€ степень Sin(x)}
      S := S + Pr
     end;
  WriteLn('—умма равна ', S : 7 : 4);
  Readln
 End.

