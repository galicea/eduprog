{ Obliczenia na duzych liczach.
  autor: Jerzy Wawro, Galicea
}
unit bint;
{$F+,O+,V-,N+,E+}
interface
{$I HDR.INC}

const
  max_size = 32;
  BISize = 32; { ilosc bajtow w liczbie (musi byc potega 2 ) }
type
  TBigInt = array[0..max_size-1] of byte;

procedure biADD(p1, p2 : TBigInt; var r : TBigInt);
{ r = p1 + p2 }
procedure biSUB(p1, p2 : TBigInt; var r : TBigInt);
{ r = p1 - p2 }
procedure biSetLong(var p : TBigInt; l : longint);
procedure biNEG(p : TBigInt; var r : TBigInt);
{ r = -p }
procedure biPOWER(p1, p2, m : TBigInt; var r : TBigInt);
procedure biDIV(p1, p2 : TBigInt; var rdiv, rmod : TBigInt);
procedure biMUL(p1, p2 : TBigInt; var r : TBigInt);

procedure biSetString(var w : TBigInt; s : string);
function biAsString(w : TBigInt) : string;
function biAsString10(w : TBigInt) : string;
function biAsLong(w : TBigInt) : longint;
function biCMP(a, b : TBigInt) : integer;
function biCMP1(a : longint; b : TBigInt) : integer;
function biZERO(a : TBigInt) : boolean;
procedure biSUCC(var p : TBigInt);
procedure biPRED(var p : TBigInt);

procedure test_bi;

implementation


type
  TLong = record
    case byte of
    0 : (lo, hi : word);
    1 : (l : longint)
  end;
  TWord = record
    case byte of
    0 : (lo, hi : byte);
    1 : (l : word)
  end;

 TZnak = (zplus, zminus, zzero);


procedure biADD(p1, p2 : TBigInt; var r : TBigInt);
var
  i1, i2, m1 : TWord;
  ii : TWord;
  i, j : word;
  s : longint;
  minus, minus1, minus2 : boolean;
  znak : array[0..BISize-1] of TZnak;
  rmov : boolean;
begin
  i:=0;
  m1.l:=0;
  minus1:=($80 and p1[BISize-1])<>0;
  minus2:=($80 and p2[BISize-1])<>0;
  rmov:=FALSE;
  for i:=0 to BISize-1 do begin
    i1.lo:=p1[i];
    i2.lo:=p2[i];
    i1.hi:=0;
    i2.hi:=0;
    ii.l:=i1.l+i2.l+m1.l;
    r[i]:=ii.lo;
    if r[i]=0 then
      IF RMOV THEN
        ZNAK[I]:=ZPLUS { jest zero, ale z przeniesienia }
      ELSE
        znak[i]:=zzero
    else if ii.l<0 then
      znak[i]:=zminus
    else
      znak[i]:=zplus;
    if (ii.l>-256) and (ii.l<256) then
      ii.hi:=0;
    rmov:=ii.hi<>0;
    m1.lo:=ii.hi;
    if ((i1.l<0)<>(i2.l<0)) and (ii.l>=0) then
      m1.lo:=m1.lo+1;
    if (m1.lo and $80)<>0 then
      m1.hi:=$FF
    else
      m1.hi:=0;
  end;
  { ustalenie znaku wyniku }
  i:=BISize-1;
  while (i>0) and (znak[i]=zzero) do
    i:=i-1;
  minus:=znak[i]=zminus;
  if minus then
    for j:=i+1 to BISize-1 do
      r[j]:=$FF;
end;

procedure biSUB(p1, p2 : TBigInt; var r : TBigInt);
var
 i : integer;
 p : byte;
begin
 { 1.1. liczymy odwrotnosc }
 biNEG(p2,p2);
 { 1.2. suma }
 biAdd(p1, p2, r);
end;

procedure biNEG(p : TBigInt; var r : TBigInt);
var
 i : integer;
begin
 { uzupelnienie do dwoch: }
 { xor }
 for i:=0 to BISize-1 do
   r[i]:=p[i] xor $FF;
 { zwieksz o 1 }
 i:=0;
 while (i<BISize) do begin
   if (r[i]=$FF) then begin
     r[i]:=0;
     i:=i+1
    end
   else begin
     inc(r[i]);
     i:=BISize
   end;
 end;
end;

procedure biSetLong(var p : TBigInt; l : longint);
begin
 if l<0 then
   FillChar(p, SizeOf(p), #$FF)
 else
   FillChar(p, SizeOf(p), #0);
 p[0]:=TWord(TLong(l).lo).lo;
 p[1]:=TWord(TLong(l).lo).hi;
 if BISize>2 then begin
   p[2]:=TWord(TLong(l).hi).lo;
   p[3]:=TWord(TLong(l).hi).hi;
 end;
end;

function biAsLong(w : TBigInt) : longint;
var
 l : TLong;
 d : TWord;
begin
 l.l:=0;
 d.lo:=w[0];
 d.hi:=w[1];
 l.lo:=d.l;
 if BISize>2 then begin
   d.lo:=w[2];
   d.hi:=w[3];
   l.hi:=d.l;
 end;
 biAsLong:=l.l
end;

procedure biSetString(var w : TBigInt; s : string);
var
 i, x : integer;

 function num(c : char) : byte;
 begin
   if c in ['A'..'F'] then
     num:=10+ord(c)-ord('A')
   else if c in ['a'..'f'] then
     num:=10+ord(c)-ord('a')
   else if c in ['0'..'9'] then
     num:=ord(c)-ord('0')
   else
     num:=0
 end;

begin
 FillChar(w, SizeOf(w), #0);
 x:=0;
 if (length(s) mod 2) <>0 then
    s:='0'+s;
 i:=length(s);
 while (i>0) and (x<BISize) do begin
   w[x]:=num(s[i])+16*num(s[i-1]);
   i:=i-2;
   x:=x+1
 end;
end;

function biAsString(w : TBigInt) : string;
var
  s : string;
  i, x : integer;
  minus : boolean;

  function hch(b : byte) : char;
  begin
    b:=b div 16;
    if b>=10 then
      hch:=chr(b+ord('A')-10)
    else
      hch:=chr(b+ord('0'));
  end;

  function lch(b : byte) : char;
  begin
    b:=b mod 16;
    if b>=10 then
      lch:=chr(b+ord('A')-10)
    else
      lch:=chr(b+ord('0'));
  end;

begin
 minus:=($80 and w[BISize-1])<>0;
 if minus then
   biNEG(w,w);
 s:='';
 for i:=0 to BISize-1 do
   s:=concat(hch(w[i]), lch(w[i]), s);
 while pos('0',s)=1 do
   delete(s,1,1);
 if length(s) mod 2 <> 0 then
   s:='0'+s;
 if minus then
   s:='-'+s;
 biAsString:=s;
end;

function biAsString10(w : TBigInt) : string;
var
  s : string;
  i, x : integer;
  minus : boolean;
  rmod, ten : TBigInt;

begin
 minus:=($80 and w[BISize-1])<>0;
 if minus then
   biNEG(w,w);
 s:='';
 biSetLong(ten, 10);
 while biCMP1(0, w)<>0 do begin
   biDIV(w, ten, w, rmod);
   s:=concat(chr(rmod[0]+ord('0')),s);
 end;
 if s='' then
   s:='0'
 else if minus then
   s:='-'+s;
 biAsString10:=s;
end;

procedure biMUL(p1, p2 : TBigInt; var r : TBigInt);
{ mnozenie }
var
  i, j, k : integer;
  minus1, minus2 : boolean;
  l : longint;
begin
  minus1:=($80 and p1[BISize-1])<>0;
  minus2:=($80 and p2[BISize-1])<>0;
  if minus1 then
    biNEG(p1, p1);
  if minus2 then
    biNEG(p2, p2);
  FillChar(r, SizeOf(r), #0);
  for i:=0 to BISize-1 do begin
    l:=0;
    for j:=0 to BISize-1-i do begin
      l:=longint(p1[i])*longint(p2[j]);
      k:=i+j;
      while (l<>0) and (k<BISize) do begin
        l:=l+r[k];
        r[k]:=l mod $100;
        l:=l div $100;
        k:=k+1;
      end;
    end;
  end;
  if minus1<>minus2 then
    biNEG(r, r);
end;


procedure biDIV(p1, p2 : TBigInt; var rdiv, rmod : TBigInt);
type
 Tpw2 = array[0..8*BISize-1] of TBigInt;
var
 i, j, m : integer;
 minus1, minus2, zero, minus : boolean;
 pw2 : ^Tpw2;
 mask : byte;
 r : TBigInt;
begin
  FillChar(rdiv, SizeOf(rdiv), #0);
  FillChar(rmod, SizeOf(rmod), #0);
  minus1:=($80 and p1[BISize-1])<>0;
  if minus1 then
    biNEG(p1,p1);
  minus2:=($80 and p2[BISize-1])<>0;
  if minus2 then
    biNEG(p2,p2);
  new(pw2);
  FillChar(pw2^, SizeOf(pw2^), #0);
  zero:=TRUE;
  i:=BISize-1;
  while (i>=0) and zero do begin
    zero:=zero and (p1[i]=0);
    if zero then
      i:=i-1
  end;
  if zero then begin
    dispose(pw2);
    exit;
  end;
  { znalezienie najstarszego bitu }
  zero:=TRUE;
  m:=8*(i+1)-1;
  mask:=$80;
  while zero do begin
    zero:=zero and ((p1[i] and mask)=0);
    if zero then begin
      mask:=mask shr 1;
      m:=m-1
    end;
  end;
  { wyliczenie iloczynow dla p1*(2^n); n=0..m }
  pw2^[0]:=p2;
  j:=0;
  while j<m do begin
    biADD(pw2^[j], pw2^[j], pw2^[j+1]);
    if (pw2^[j][BISize-1]>=63) then
       pw2^[j+1][BISize-1]:= pw2^[j+1][BISize-1] or $80;
    j:=j+1;
  end;
  { odejmowanie - od najstarszej }
  rmod:=p1;
  while (j>=0) do begin
    if (pw2^[j][BISize-1] and $80)=0 then begin
      biSUB(rmod, pw2^[j], r);
      minus:=($80 and r[BISize-1])<>0;
      if not minus then begin
        rmod:=r;
        rdiv[i]:=rdiv[i] or mask;
      end;
    end;
    j:=j-1;
    if mask=1 then begin
      mask:=$80;
      i:=i-1
     end
    else
      mask:=mask shr 1;
  end;
  if minus1<>minus2 then begin
    biNEG(rdiv,rdiv);
  end;
  if minus1 then begin
    biNEG(rmod,rmod);
  end;
  dispose(pw2);
end;

procedure biPOWER(p1, p2, m : TBigInt; var r : TBigInt);
{ potegowanie p1^p2 mod m
  zaklada ze p2>0 !!!!! }

type
 Tpw2 = array[0..8*BISize-1] of TBigInt;
var
 i, j, m1 : integer;
 minus1, minus2, zero : boolean;
 mask : byte;
 pw2 : ^Tpw2;
 mm, rr : TBigInt;
begin
  FillChar(r, SizeOf(r), #0);
  minus1:=($80 and p1[BISize-1])<>0;
  if minus1 then
    biNEG(p1,p1);
  minus2:=($80 and p2[BISize-1])<>0;
  if minus2 then
    exit;
  zero:=TRUE;
  i:=BISize-1;
  while (i>=0) and zero do begin
    zero:=zero and (p2[i]=0);
    if zero then
      i:=i-1
  end;
  if zero then begin
    biSetLong(r,1);
    exit;
  end;
  { znalezienie najstarszego bitu }
  zero:=TRUE;
  m1:=8;
  mask:=$80;
  while zero and (m1>0) do begin
    zero:=zero and ((p2[i] and mask)=0);
    if zero then begin
      mask:=mask shr 1;
      m1:=m1-1
    end;
  end;
  { wyliczenie poteg p2^(2^n) }
  new(pw2);
  FillChar(pw2^, SizeOf(pw2^), #0);
  pw2^[0]:=p1;
  j:=0; m1:=m1+8*i+1;
  while m1>=0 do begin
    biMUL(pw2^[j], pw2^[j], rr);
    biDIV(rr, m, rr, pw2^[j+1]);
    j:=j+1;
    m1:=m1-1;
  end;
  { mnozenie przez potegi, dla ktorych w reprezentacji
    dwojkowej p2 wystepuje 1 }
  biSetLong(r,1);
  mask:=1;
  i:=0; j:=0;
  while i<BISize do begin
    if (p2[i] and mask)<>0 then begin
      biMUL(r, pw2^[j], rr);
      biDIV(rr, m, rr, r);
    end;
    if mask=$80 then begin
      mask:=1;
      i:=i+1
     end
    else
      mask:=mask shl 1;
    j:=j+1;
  end;
  if minus1 and ((p2[0] and $01)<>0) then
    biNEG(r,r);
  dispose(pw2);
end;


function biCMP(a, b : TBigInt) : integer;
var
 r : TBigInt;
begin
 biSUB(a,b,r);
 if biZERO(r) then
   biCMP:=0
 else if ($80 and r[BISize-1])=0 then
   biCMP:=1
 else
   biCMP:=-1;
end;

function biCMP1(a : longint; b : TBigInt) : integer;
var
 ai, r : TBigInt;
begin
 biSetLong(ai, a);
 biSUB(ai,b,r);
 if biZERO(r) then
   biCMP1:=0
 else if ($80 and r[BISize-1])=0 then
   biCMP1:=1
 else
   biCMP1:=-1;
end;

function biZERO(a : TBigInt) : boolean;
var
 i : integer;
begin
 for i:=0 to BISize-1 do
   if a[i]<>0 then begin
     biZERO:=FALSE;
     exit
   end;
 biZERO:=TRUE;
end;

procedure biSUCC(var p : TBigInt);
var
 i : integer;
begin
 i:=0;
 while (i<BISize) do begin
   if (p[i]=$FF) then begin
     p[i]:=0;
     i:=i+1
    end
   else begin
     inc(p[i]);
     i:=BISize
   end;
 end;
end;

procedure biPRED(var p : TBigInt);
var
 p1 : TBigInt;
begin
 biSetLong(p1, 1);
 biSUB(p,p1,p);
end;

procedure test_bi;
var
  bi1, bi2, w, w1 : TBigInt;
  l1, l2, l : longint;
  d : double;
  a : TBigInt;
begin
  write('l1=');readln(l1);
  write('l2=');readln(l2);
  biSetLong(bi1, l1);
  writeln('l1=',l1,'   bi1= ',biAsString10(bi1));
  biSetLong(bi2, l2);
  writeln('l2=',l2,'   bi2= ',biAsString10(bi2));
  biNEG(bi2, w);
  writeln('-bi2    =',biAsString10(w):14);
  l:=l1+l2;
  writeln('l1+l2   =',l:14);
  biADD(bi1, bi2, w);
  writeln('bi1+bi2 =',biAsString10(w):14);
  l:=l1-l2;
  writeln('l1-l2   =',l:14);
  biSUB(bi1, bi2, w);
  writeln('bi1-bi2 =',biAsString10(w):14);

  d:=l1;
  d:=d*l2;
  writeln('l1*l2   =',d:14:0);
  biMUL(bi1, bi2, w);
  write('bi1*bi2 =',biAsString10(w):14);writeln('  = w');
  biDIV(w, bi1, w, w1);
  writeln('w/b1    =',biAsString10(w):14);
  writeln('reszta  =',biAsString10(w1):14);
  biDIV(bi1, bi2, w, w1);
  l:=l1 div l2;
  writeln('l1/l2   =',l:14);
  l:=l1 mod l2;
  writeln('reszta  =',l:14);
  writeln('bi1/bi2 =',biAsString10(w):14);
  writeln('reszta  =',biAsString10(w1):14);
  biSetLong(w1, $7fffffff);
  biPOWER(bi1, bi2, w1, w);
  writeln('bi1^bi2=',biAsString10(w):14);
  readln;
end;

end.

