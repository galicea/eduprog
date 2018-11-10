(******************************************************************
  Algorytm szyfrowanie RSA z uzyciem duzych liczb (zob bint.pas)
  Pure Pascal

  autor: Jerzy Wawro, Galicea

*******************************************************************)

{$F+,O+,V-,N+,E+}
{$I HDR.INC}
uses
{$IFDEF DOS}
 DosUtils,
{$ELSE}
 SysUtils,
{$ENDIF}
 bint;

var
  p, q, d, e, n : TBigInt;


procedure gcd(d1, d2 : TBigInt; var w : TBigInt);
  { szuka najwiekszego wspolnego podzielnika; d1, d2 >0 }
  { zob. algorytm Euklidesa }
var
  r0, r1, tmp, x : TBigInt;
begin
  if biCMP(d1,d2)>0 then begin
    r0:=d1;
    r1:=d2
   end
  else begin
    r0:=d2;
    r1:=d1
  end;
  while biCMP1(0, r1)<0 do begin
    x:=r1;
    biDIV(r0, r1, tmp, r1); { r1:=r0 mod r1; }
    r0:=x
  end;
  w:=r0;
end;

procedure inv(a, n : TBigInt; var res : TBigInt);
  { szuka x, dla ktorego a*x mod n = 1, przy 0 < a < n }
  { rozszerzony algorytm Euklidesa }
 var
  r1, r0 : TBigInt;
  v1, v0 : TBigInt;
  x, d, m, w : TBigInt;
begin
  r0:=n;  biSetLong(v0, 0); { v0=0; u0 = 1 }
  r1:=a;  biSetLong(v1, 1); { v1=1; u1 = 0 }
  while not biZERO(r1) do begin { r1 :=ui*n + vi*a }
    biDIV(r0,r1,d,m); { d:=r0 div r1; }
    biMUL(d, r1, w); biSUB(r0, w, x); { x:=r0-d*r1; }
    r0:=r1;
    r1:=x;
    biMUL(d, v1, w); biSUB(v0, w, x); { x:=v0-d*v1; }
    v0:=v1;
    v1:=x;
  end;
  if biCMP1(0,v0)<=0 then
    res:=v0
  else
   biADD(v0, n, res); { res:=v0+n }
end;


procedure rsa_keys(p, q : TBigInt; var d, e, n : TBigInt);
{ szuka kluczy d, e dla dwoch liczb pierwszych p i q }
{ przy okazji oblicza n }
var
 fi, wd : TBigInt;
 tmp1, tmp2 : TBigInt;
 b : boolean;
begin { rsa_kyes }
 biMUL(p, q, n); { n:=p*q }
 tmp1:=p; biPRED(tmp1);
 tmp2:=q; biPRED(tmp2);
 biMUL(tmp1, tmp2, fi); { fi:=(q-1)*(p-1); }
 { wybieramy e wzglednie pierwsze wzgledem fi
   z przedzialu [max(p, q) +1 .. n-1] }
 if biCMP(p,q)>0 then begin
   d:=p; biSUCC(d); { d:=p+1 }
  end
 else begin
   d:=q; biSUCC(d); { d:=q+1 }
 end;
 b:=FALSE;
 while (not b) and (biCMP(d,n)<0) do begin
   gcd(d, fi, wd);
   if biCMP1(1,wd)<>0 then
     biSUCC(d)
   else
     b:=TRUE;
 end;
 if not b then begin
    writeln('nie znaleziono kluczy');
    halt
 end;
 inv(d, fi, e);
end; { rsa_kyes }

procedure rsa(M, d, n : TBigInt; var w : TBigInt);
begin
  biPOWER(M, d, n, w);
end;



{ generator liczb pseudolosowych }
const m  = 167876866;
      m1 = 7687;
      b  = 2141821;
      maxl = 256;

var
  seed: longint;

function gen : byte;
var
  N : double;

   function mult (p,q : longint): longint;
   var p0, p1, q0, q1: longint;
   begin
      p1:=p div m1;
      p0:=p mod m1;
      q1:=q div m1;
      q0:=q mod m1;
      mult:=( (p0*q1 mod m1 + p1*q0 mod m1)*m1 + p0*q0) mod m;
   end;

begin
   N:=Now;
   N:=(1000*N-1000*(100*round(N/100-1)));
   N:=(1111*N-1111*(100*round(N/100-1)));
   seed:=seed+round(N);
   seed:=(mult(seed,b)+1) mod m;
   gen := round(seed mod maxl)
end;

procedure losuj(lbound, hbound : TBigInt; var los : TBigInt);
var
 i : integer;
 r : TBigInt;
begin
  repeat
    for i:=0 to BISize-1 do
      los[i]:=gen;
    if los[BISize-1]< lbound[BISize-1] then
      los[BISize-1]:=lbound[BISize-1];
    los[BISize-1]:=los[BISize-1] and $3F;
    biDIV(los, hbound, r, los);
    i:=biCMP(los, lbound);
  until i>0;
end;


function test_fermata(b : TBigInt) : boolean;
{ sprawdzenie czy liczba jest pierwsza }
const
 c : longint = 0;
var
 a, w : TBigInt;
 i : integer;

 procedure losuj_b_1(var a : TBigInt);
 { losuje liczbe z przedzialu 1 .. b-1 }
 begin
   biSETLong(a, 1);
   losuj(a, b, a);
 end;

begin
 i:=200;
 while i>0 do begin
   losuj_b_1(a);
   gcd(a, b, w);
   if biCMP1(1,w)<>0 then begin
     test_fermata:=FALSE;
     exit
   end;
   i:=i-1
 end;
 test_fermata:=TRUE; { chyba pierwsza }
end;

(*======================================*)

procedure znajdz_pq(var p, q : TBigInt);
{ szuka pary p, q }
const
 maxd = 5; { maksymalna ilosc bajtow w liczbie q -
             musi byc dobrana w zaleznosci od BISize
             n musi sie miescic w tabeli TBigInt;
             jesli algorytm poszukiwania klucza
             nie zatrzymuje sie - zmniejsz maxd }
var
 minq, maxq : TBigInt;
 ok : boolean;

begin
 FillChar(maxq, SizeOf(maxq), #0);
 FillChar(minq, SizeOf(minq), #0);
 maxq[maxd]:=1;
 minq[maxd-1]:=1;
 repeat
   write('+');
   repeat
     losuj(minq, maxq, q);
     write('.');
   until test_fermata(q);
   { p = 2*q +1 ( zalecana zaleznosc - choc teoretycznie p moze byc dowolne) }
   biADD(q,q,p);
   biSUCC(p);
   p[BISize-1] := p[BISize-1] and $7f;
 until test_fermata(p) ;
end; { znajdz_pq }


procedure genk;
{ generuje klucze }
{ szuka NP par, wybiera takie, ktore:
  1. sa bezpieczne, czyli p=2q +1 (zob procedure znajdz_pq)
  2. NWP (p-1, q-1) mozliwie maly }

const
 NP = 3;
var
 w, pp, qq, ee, dd, nn, tmp, tmp1, gcd_pq : TBigInt;
 i, l : integer;
 txt : text;
begin
 write('Podaj liczbe (0..2000000000) inicjujaca generator liczb: ');
 readln(seed);
 for i:=1 to NP do begin
   write('[',i,']');l:=1;
   repeat
     write('pq nr ',l,' ');l:=l+1;
     znajdz_pq(pp,qq);
     rsa_keys(pp, qq, dd, ee, nn);
     writeln('sprawdzam');
     biSetLong(w,2);
     rsa(w, ee, nn, w);
     rsa(w, dd, nn, w);
   until biCMP1(2,w)=0;
   if i=1 then begin
     p:=pp; q:=qq; e:=ee; d:=dd; n:=nn;
     biPRED(pp); biPRED(qq);
     gcd(pp,qq,gcd_pq)
    end
   else begin
     tmp:=pp; tmp1:=qq;
     biPRED(tmp); biPRED(tmp1);
     gcd(tmp,tmp1, tmp);
     if biCMP(tmp, gcd_pq)<0 then begin
       p:=pp; q:=qq; e:=ee; d:=dd; n:=nn;
       gcd_pq:=tmp;
     end;
   end;
 end;
 writeln('zapisuje');
 assign(txt, 'rsa.key');
 rewrite(txt);
 writeln(txt,'p=',biAsString(p));
 writeln(txt,'q=',biAsString(q));
 writeln(txt,'d=',biAsString(d));
 writeln(txt,'e=',biAsString(e));
 writeln(txt,'n=',biAsString(n));
 close(txt);
end;


procedure czytaj_klucz(szyfr : boolean);
var
  txt : text;
  s : string;
begin
 biSetLong(p,0);
 biSetLong(q,0);
 biSetLong(e,0);
 biSetLong(d,0);
 biSetLong(n,0);
 if not FileExists('rsa.key') then begin
   writeln('brak klucza (plik rsa.key)');halt
 end;
 assign(txt, 'rsa.key');
 reset(txt);
 while not eof(txt) do begin
   readln(txt,s);
   if pos('p=',s)=1 then
     biSetString(p,copy(s,3,255))
   else if pos('q=',s)=1 then
     biSetString(q,copy(s,3,255))
   else if pos('e=',s)=1 then
     biSetString(e,copy(s,3,255))
   else if pos('d=',s)=1 then
     biSetString(d,copy(s,3,255))
   else if pos('n=',s)=1 then
     biSetString(n,copy(s,3,255))
   else begin
     writeln('Bledny klucz');
     close(txt);
     halt
   end;
 end;
 close(txt);
 if (szyfr and biZERO(d)) or
    (not szyfr and biZERO(e)) or
    biZERO(n) then begin
   writeln('Brak pelnych informacji o kluczu');
   halt
 end;
end;

procedure help;
begin
  writeln('Algorytm szyfrowanie RSA.');
  writeln('(C) Tenar 2001, wersja 1.00 FreeWare, autor: Jerzy Wawro');
  writeln('Program moze byc uzywany swobodnie - takze do celow komercyjnych,');
  writeln('ale bez zadnych gwarancji ze strony autora lub firmy TENAR.');
  writeln;
   writeln('Program mozna wykonac z parametrami okreslajacym operacje:');
   writeln('  rsa <operacja> [<liczba szesnastkowa>]');
   writeln('   k - wyliczenie klucza i zapisanie go w pliku rsa.key');
   writeln('   s - szyfrowanie liczby');
   writeln('   d - odszyfrowywanie');
   writeln('Operacje s i k czytaja klucz z pliku rsa.key');
   writeln('Wynik jest zapisywany do standardowego pliku wyjsciowego.');
   writeln('Przyklady:  rsa k');
   writeln('            rsa d 80989');
   writeln('            rsa s A012 > wynik.txt');
end;

var
  w : TBigInt;
  op, h : string;


begin
 if ParamCount=0 then begin
   help;
   write('Twoj wybor: (k,s,d,q): ');
   readln(op);
   h:='';
  end
 else begin
   op:=ParamStr(1);
   h:=ParamStr(2);
 end;
 op:=UpperCase(op);
 if (op='-?') or (pos('HELP',op)<>0) then
   help
 else  if length(op)<>1 then
   writeln('Zle wywolanie programu')
 else
   case op[1] of
    'K': genk;
    'S': begin
          czytaj_klucz(TRUE);
          if h='' then begin
            write('Wiadomosc (liczba szesnastkowa)');
            readln(h);
          end;
          biSetString(w, h);
          rsa(w, d, n, w);
          writeln(biAsString(w));
         end;
    'D': begin
          czytaj_klucz(FALSE);
          if h='' then begin
            write('Wiadomosc (liczba szesnastkowa)');
            readln(h);
          end;
          biSetString(w, h);
          rsa(w, e, n, w);
          writeln(biAsString(w));
         end;
     'q': halt;
     else writeln('Bledny wybor funkcji')
   end;
end.
