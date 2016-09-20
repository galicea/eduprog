(*
* Analizator LL(1) prostych wyrazen arytmetycznch.
*
*
* wersja 1.01
* author: Jerzy Wawro
*
*>--Copyright (c) 1991-2016, Galicea <fundacja@galicea.org>
*>--All rights reserved.
*>--License FreeBSD: see license.txt for details.
*)
program kalk_ll1;

uses Crt, Dos,
     scaner;

const
  StackSize = 25; {Maksymalna wielkosc stosu dla analizatora}


var
  Stack : array [0..StackSize] of Token;
  StackTop : word;
  ParseError : word;
  x : word;
  blad, koniec : boolean;
  TK : Token;
  t  : word;
  sin : string;

procedure parser;

var
 res : real;

procedure scan;
begin
 NextToken(sin,TK,x,ParseError);
 t:=TK.symb;
end; {scan}

procedure expression;

procedure term; { skladnik }
var
 r1 : real;

procedure factor; { czynnik }
begin
 res:=0;
 if t=NUMSYM then begin
   res:=TK.r;
   scan
  end
 else if t=LPAREN then begin
   scan;
   expression;
   if blad then
      exit;
   if t=RPAREN then
     scan
   else
     blad:=TRUE;
 end;
end; {factor}

begin {term}
 factor;
 r1:=res;
 while (t in [MULSYM, DIVSYM]) and (not blad) do begin
   if t=MULSYM then begin
     scan;
     factor;
     r1:=r1*res
    end
   else begin
     scan;
     factor;
     r1:=r1/res
   end;
 end;
 res:=r1
end; {term}

var
 r2 : real;

begin {expression}
 res:=0;
 term;
 r2:=res;
 while (t in [ADDSYM, SUBSYM]) and (not blad) do begin
   if t=ADDSYM then begin
     scan;
     term;
     r2:=r2+res
    end
   else begin
     scan;
     term;
     r2:=r2-res
   end;
 end;
  res:=r2
end; {expression}


begin {parser}
 scan;
 expression;
 if t<>EOINSYM then
    blad:=TRUE;
 TK.r:=res
end; {parser}

begin
  Stack[0].state:=0;
  StackTop :=0;
  ParseError:=0;
  x :=1;
  blad:=FALSE;
  koniec :=FALSE;
  write('wyrazenie:');
  readln(sin);
  parser;
  if blad then writeln('Blad')
  else  writeln('wynik: ',TK.r:10:2);
  write('Nacisnij Enter');readln;
end.
