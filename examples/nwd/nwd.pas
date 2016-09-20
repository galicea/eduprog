// start
var a,b : integer;
begin
//czytaj(a,b);
write('a=');readln(a);
write('b=');readln(b);
// szukaj_nwp
while a<>b do if a<b then b:=b-a else a:=a-b;
// wypisz_wynik;
writeln('NWP=',a);
//stop
end.