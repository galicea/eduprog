
var
 wiek : array[1..1000] of integer;
 ilosc : integer;

procedure posortowac_zbior;
var
  i, j : integer;
  m, mi : integer;
begin
 for i:=1 to ilosc do begin
   m:=wiek[i];
   mi:=i;
   for j:=i+1  to ilosc do
     if m<wiek[j] then begin
       m:=wiek[j];
       mi:=j
     end;
   wiek[mi]:=wiek[i];
   wiek[i]:=m
 end;
end;

function wybierz_srodkowy : integer;
var
  ix:integer;
begin
  ix:=ilosc div 2;
  if ix*2<ilosc then
    ix:=ix+1;
  exit(wiek[ix]);
end;

var
 i : integer;
begin
 wiek[1]:=9;wiek[2]:=7;wiek[3]:=11;wiek[4]:=1;wiek[5]:=10;
 ilosc:=5;
 posortowac_zbior;
 for i:=1 to ilosc do
   writeln(wiek[i]);
 writeln('mediana=',wybierz_srodkowy);
end.