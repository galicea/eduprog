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

  res : real;

procedure Push(TK : Token);
{ Token na stos }
begin
  if StackTop = StackSize then begin
    writeln('Za maly stos !');
    blad:=TRUE
   end
  else begin
    Inc(StackTop);
    Stack[StackTop] := TK
  end;
end; { Push }

procedure Pop(var TK : Token);
{ Token ze stosu }
begin
  TK := Stack[StackTop];
  Dec(StackTop);
end; { Pop }

function AktualnyStan : byte;
begin
  AktualnyStan:=Stack[StackTop].State
end; { AktualnyStan }

procedure NowyStan(st : word);
begin
  TK.State := st;
  Push(TK);
end; { NowyStan }

procedure Przesuniecie( st : word );
begin
 NowyStan(st);
 NextToken(sin,TK,x,ParseError);
 t := TK.symb;
end; { Przesuniecie }


{------ z generatora --------}
{ produkcje:
1 :  <Z> ::= <W>
2 :  <W> ::= <W> + <A>
3 :  <W> ::= <W> - <A>
4 :  <W> ::= <A>
5 :  <A> ::= <A> * <A>
6 :  <A> ::= <A> / <A>
7 :  <A> ::= <B>
8 :  <B> ::= + <C>
9 :  <B> ::= - <C>
10 :  <B> ::= <C>
11 :  <C> ::= ( <W> )
12 :  <C> ::= NUM
STANY :
1 :  <W>
2 :  <W>+
3 :  <W>+<A>
4 :  <W>-
5 :  <W>-<A>
6 :  <A>
7 :  <A>*
8 :  <A>*<A>
9 :  <A>/
10 :  <A>/<A>
11 :  <B>
12 :  +
13 :  +<C>
14 :  -
15 :  -<C>
16 :  <C>
17 :  (
18 :  (<W>
19 :  (<W>)
20 :  NUM
}

function PoRedukcji(produkcja : word) : word;
var
 st : byte;
begin
 st := AktualnyStan;
 case produkcja of
   2, 3, 4 : case st of
      17 : PoRedukcji := 18;
      else PoRedukcji := 1;
     end;
   5, 6, 7 : case st of
      2 : PoRedukcji := 3;
      4 : PoRedukcji := 5;
      7 : PoRedukcji := 8;
      9 : PoRedukcji := 10;
      else PoRedukcji := 6;
     end;
   8, 9, 10 : PoRedukcji := 11;
   11, 12 : case st of
      12 : PoRedukcji := 13;
      14 : PoRedukcji := 15;
      else PoRedukcji := 16;
     end;
 end; {case produkcja}
end; { PoRedukcji }


procedure redukcja(produkcja : word);
var
 TK1, TK2, TK3 : token;
begin
  case produkcja of
   { zdj‘cie ze stosu element¢w prawej strony produkcji,
     wygenerowanie kodu, lub wykonanie oblicze¤ }
   1: begin  { <Z> ::= <W> }
       pop(TK);
       end;
   2: begin  { <W> ::= <W> + <A> }
       pop(TK1);
       pop(TK2);
       pop(TK3);
       TK.r:=TK3.r+TK1.r
       end;
   3: begin  { <W> ::= <W> - <A> }
       pop(TK1);
       pop(TK2);
       pop(TK3);
       TK.r:=TK3.r-TK1.r
       end;
   4: begin  { <W> ::= <A> }
       pop(TK);
       end;
   5: begin  { <A> ::= <A> * <A> }
       pop(TK1);
       pop(TK2);
       pop(TK3);
       TK.r:=TK3.r*TK1.r
       end;
   6: begin  { <A> ::= <A> / <A> }
       pop(TK1);
       pop(TK2);
       pop(TK3);
       TK.r:=TK3.r/TK1.r
       end;
   7: begin  { <A> ::= <B> }
       pop(TK);
       end;
   8: begin  { <B> ::= + <C> }
       pop(TK);
       pop(TK1);
       end;
   9: begin  { <B> ::= - <C> }
       pop(TK);
       pop(TK1);
       TK.r:=-TK.r
       end;
   10: begin  { <B> ::= <C> }
       pop(TK);
       end;
   11: begin  { <C> ::= ( <W> ) }
       pop(TK1);
       pop(TK);
       pop(TK1);
       end;
   12: begin  { <C> ::= NUM }
       pop(TK);
       end;
  end; { case }
  NowyStan(PoRedukcji(produkcja));
end; { Redukcja }

procedure parser;
var
  st : word;
begin
 NextToken(sin,TK,x,ParseError);
 t:=TK.symb;
 repeat
   st:=AktualnyStan;
   if (st=1) and (t=EOINSYM) then
       koniec:=TRUE else
   case st of
    0, 2, 4, 7, 9, 17 : case t of
     ADDSYM :  przesuniecie(12);
     SUBSYM :  przesuniecie(14);
     LPAREN :  przesuniecie(17);
     NUMSYM :  przesuniecie(20);
    end;
    1 : case t of
     ADDSYM :  przesuniecie(2);
     SUBSYM :  przesuniecie(4);
    end;
    3 : case t of
     EOINSYM :  redukcja(2);
     ADDSYM :  redukcja(2);
     SUBSYM :  redukcja(2);
     MULSYM :  przesuniecie(7);
     DIVSYM :  przesuniecie(9);
     LPAREN :  redukcja(2);
     RPAREN :  redukcja(2);
     NUMSYM :  redukcja(2);
    end;
    5 : case t of
     EOINSYM :  redukcja(3);
     ADDSYM :  redukcja(3);
     SUBSYM :  redukcja(3);
     MULSYM :  przesuniecie(7);
     DIVSYM :  przesuniecie(9);
     LPAREN :  redukcja(3);
     RPAREN :  redukcja(3);
     NUMSYM :  redukcja(3);
    end;
    6 : case t of
     EOINSYM :  redukcja(4);
     ADDSYM :  redukcja(4);
     SUBSYM :  redukcja(4);
     MULSYM :  przesuniecie(7);
     DIVSYM :  przesuniecie(9);
     LPAREN :  redukcja(4);
     RPAREN :  redukcja(4);
     NUMSYM :  redukcja(4);
    end;
    8 : case t of
     EOINSYM :  redukcja(5);
     ADDSYM :  redukcja(5);
     SUBSYM :  redukcja(5);
     MULSYM :  przesuniecie(7);
     DIVSYM :  przesuniecie(9);
     LPAREN :  redukcja(5);
     RPAREN :  redukcja(5);
     NUMSYM :  redukcja(5);
    end;
    10 : case t of
     EOINSYM :  redukcja(6);
     ADDSYM :  redukcja(6);
     SUBSYM :  redukcja(6);
     MULSYM :  przesuniecie(7);
     DIVSYM :  przesuniecie(9);
     LPAREN :  redukcja(6);
     RPAREN :  redukcja(6);
     NUMSYM :  redukcja(6);
    end;
    11 : redukcja(7);
    12, 14 : case t of
     LPAREN :  przesuniecie(17);
     NUMSYM :  przesuniecie(20);
    end;
    13 : redukcja(8);
    15 : redukcja(9);
    16 : redukcja(10);
    18 : case t of
     ADDSYM :  przesuniecie(2);
     SUBSYM :  przesuniecie(4);
     RPAREN :  przesuniecie(19);
    end;
    19 : redukcja(11);
    20 : redukcja(12);
  end; { case }
 until koniec or blad;
end; { parser }

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
  write('nacisnij Enter');readln;
end.

