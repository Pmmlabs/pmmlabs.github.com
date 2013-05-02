type TMonth = (Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Decem);
     TYear =  1901..2001;
     TDate = record
              day: 1..31;
              month: TMonth;
              year: TYear;
 end;
var Date:TDate;
function IntToMonth(n: integer): TMonth;
begin
 case N of
  1: IntToMonth := Jan;
  2: IntToMonth := Feb;
  3: IntToMonth := Mar;
  4: IntToMonth := Apr;
  5: IntToMonth := May;
  6: IntToMonth := Jun;
  7: IntToMonth := Jul;
  8: IntToMonth := Aug;
  9: IntToMonth := Sep;
  10: IntToMonth := Oct;
  11: IntToMonth := Nov;
  12: IntToMonth := Decem;
 end;
end;
procedure InputDate(var Date: TDate);
 var n: byte;
 begin
   writeln('¬ведите сегодн€шнюю дату.');
   writeln;
   write('¬ведите день: ');
    repeat
      readln(date.day);
    until date.day in [1..31] ;
   write('¬ведите мес€ц числом (1 - €нварь, 2 - февраль и т. д.): ');
    repeat
      readln(n);
    until n in [1..12] ;
   date.month := IntToMonth(n);
   write('¬ведите год (от 1901 до 2001): ');
    repeat
      readln(date.year)
    until (date.year >= 1901) and (date.year <= 2001) ;
 end;
procedure PrintMonth(Date: TDate);
 begin
  case Date.month of
   Jan: write(' €нвар€ ');
   Feb: write(' феврал€ ');
   Mar: write(' марта ');
   Apr: write(' апрел€ ');
   May: write(' ма€ ');
   Jun: write(' июн€ ');
   Jul: write(' июл€ ');
   Aug: write(' августа ');
   Sep: write(' сент€бр€ ');
   Oct: write(' окт€бр€ ');
   Nov: write(' но€бр€ ');
   Decem: write(' декабр€ ');
  end;
 end;
procedure PrintDate(Date: TDate);
 begin
     write(Date.day);
     PrintMonth(Date);
     write(Date.year, ' года.')
 end; 
function IsLeap(Year:Integer):Boolean;
 begin
   IsLeap:=(Year mod 4 = 0) and (Year mod 4000 <> 0) and
     ((Year mod 100 <> 0) or (Year mod 400 = 0));
    end;
function DaysInMonth(Date:TDate):integer;
 begin
  case Date.month of Feb:
    begin
      if IsLeap(Date.year) then DaysInMonth := 29
                      else DaysInMonth := 28;
    end;
   Apr, Jun, Sep:
    DaysInMonth := 30;
  else DaysInMonth := 31;
  end;
end;
procedure IncDate(var date: TDate);
begin
   inc(Date.day);
   if (Date.day > DaysInMonth(Date)) then  //день завышен
                                         begin
                                          Date.day:= 1;
                                          inc(Date.month);
                                            if ((ord(Date.month)+1) > 12) then //мес€ц завышен
                                              begin
                                               Date.month:= Jan;
                                               inc(Date.year);
                                              end;
                                        end;
end;
begin
 InputDate(Date);
 writeln;
 write('—егодн€ ');
 PrintDate(Date);
 write(' «автра ');
 IncDate(Date);
 PrintDate(Date);
 readln;
end.