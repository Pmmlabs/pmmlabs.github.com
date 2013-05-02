program Project1;
{$APPTYPE CONSOLE}
uses
  SysUtils,
  Windows;
var
   c:char;
   sb,sz:integer;
   curgroup:byte;
   stop:boolean;
begin
   curgroup:=3;
   SetConsoleCp(1251); SetConsoleOutputCp(1251);
   while not stop do begin
      read(c);
      case c of
          'A'..'Z','a'..'z': begin if curgroup<>0 then begin sb:=sb+1; curgroup:=0; end; end;
          '0'..'9': if curgroup<>1 then curgroup:=1;
          '+','-','*': begin if curgroup<>2 then begin sz:=sz+1; curgroup:=2; end; end;
          else stop:=true;
      end;
   end;
   if sb>sz then writeln('Верно') else writeln('Неверно');
   readln;
   readln;
end.
