program str98n16a;

{$APPTYPE CONSOLE}

uses
  SysUtils,windows;

type country=(Austria, Canada, China, Italy, Peru, USA);
     continent=(America, Africa, Asia, Europe);
     TnameCntr=array[country] of string;
     TnameCntnnt=array[continent] of string;
const names:TnameCntr=('Àâñòğèÿ','Êàíàäà','Êèòàé','Èòàëèÿ','Ïåğó','ÑØÀ');  // ìàññèâ ğóññêèõ íàçâàíèé ñòğàí
      names2:TnameCntnnt=('Àìåğèêà','Àôğèêà','Àçèÿ','Åâğîïà');             // ìàññèâ ğóññêèõ íàçâàíèé êîíòèíåíòîâ
var tmp:country;        // ïåğåìåííàÿ äëÿ öèêëà (ïàğàìåòğ)
    i:integer;
    t:continent;
function CountryToContinent(var cntr:country):continent; // ôóíêöèÿ ñîïîñòàâëåíèÿ ñòğàíå êîíòèíåíòà
 begin
  case cntr of                     // ïğîâåğÿåì ïåğåäàííûé â ôóíêöèş ïàğàìåòğ
   Austria: result:=Europe;
   Canada: result:=America;
   China: result:=Asia;
   Italy: result:=Europe;
   Peru: result:=America;
   USA: result:=America;
   end;
 end;
begin
 SetConsoleCP(1251);                  // óñòàíîâêà êîäèğîâêè Êèğèëëèöà 1251
 SetConsoleOutputCP(1251);
  writeln('Ââåäèòå íîìåğ ñòğàíû:');
  for tmp:=Austria to USA do writeln(ord(tmp)+1,' - ',names[tmp]);  // ïå÷àòü ìåíş äëÿ âûáîğà ñòğàíû
  repeat readln(i);                                                 // ÷òåíèå âûáîğà ïîëüçîâàòåëÿ
  until (i>=1) and (i<=ord(High(country))+1);                       // íîìåğ äîëæåí ñîîòâåòñòâîâàòü ñòğàíå èç ìíîæåñòâà country
  write(names[country(i-1)],' íàõîäèòñÿ íà êîíòèíåíòå ');
  tmp := country(i-1);
  writeln(' ',names2[CountryToContinent(tmp)]); //âûâîä ğåçóëüòàòà,
  readln;                                      //ò.å âûâîä ñîîòâåòñòâóşùåãî ıëåìåíòà ìàññèâà names2
end.
 