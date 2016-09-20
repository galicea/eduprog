(*
*  analizator leksykalny
*
*
* wersja 1.00
* author: Jerzy Wawro
*
*>--Copyright (c) 1991-2016, Galicea <fundacja@galicea.org>
*>--All rights reserved.
*>--License FreeBSD: see license.txt for details.
*)
unit scaner;
{ ---------- symbole scanera ---------------}
interface
const
  ADDSYM    = 1;  { + }
  ANDSYM    = 2;  { AND }
  BADSYM    = 3;  { nieznany token  }
  COMMASYM  = 4;  { . }
  DIVSYM    = 5;  { / }
  EOINSYM   = 6;  { koniec ’a¤cucha }
  EQUSYM    = 7;  { = }
  GESYM     = 8;  { >= }
  GTSYM     = 9;  { > }
  IDSYM     = 10; { identyfikator }
  ISSYM     = 11; { :- }
  LESYM     = 12; { <= }
  LPAREN    = 13; { ( }
  LTSYM     = 14; { > }
  MULSYM    = 15; { * }
  NESYM     = 16; { <> }
  NOTSYM    = 18; { NOT }
  NUMSYM    = 19; {liczba }
  ORSYM     = 21; { OR }
  RPAREN    = 22; { ) }
  STRINGSYM = 24; { napis ograniczony znakami '' }
  SUBSYM    = 25; { - }

type
  Token = record
    symb : byte;  { stala oznaczajaca token }
    state : byte; { stan automatu analizatora }
    case Byte of
      0 : (r : real); { liczba }
      1 : (sb, sl : word); { poczatek i dlugosc napisu w lancuchu wejsciowym}
  end;

procedure NextToken(var ss: string; var TK : Token;
	            var x : word; var ParseError : word);
{... Procedura pobiera nastepny symbol z napisu ss ...}
{ Napis jest obcinany z lewej (symbol jest usuwany);  }
{ Pobrany token jest zwracany poprzez zmienna TK      }

implementation

procedure NextToken(var ss: string; var TK : Token;
	            var x : word; var ParseError : word);

  var
    i,j,k : integer;
    sp : string;
    ch : char;
    ok : boolean;

 function start(symStr : string ; sym : byte) : boolean;
  var l : word;
  begin
   if pos(symStr,ss)=1 then begin
     l:=length(symStr);
     delete(ss,1,l);
     TK.symb:=sym;
     x:=x+l;
     start:=TRUE;
    end
   else
     start:=FALSE
  end; {start}

begin {NextToken}
 with TK do begin
  ParseError:=0;
  symb:=BADSYM;
  while pos(' ',ss)=1 do begin
    delete(ss,1,1);
    x:=x+1
  end;
  if ss='' then
    symb:=EOINSYM
  else begin
    ch:=ss[1];
    if ch in ['0'..'9'] then begin {liczba}
      i:=1;
      ok:=TRUE;
      while ok and (i<length(ss)) do begin
	i:=i+1;
	if ss[i] in ['-','+'] then
	  ok:=ss[i-1]='E'
	else
	  ok:=ss[i] in ['0'..'9','.','E']
      end;
      if not ok then
	i:=i-1;
      sp:=copy(ss,1,i);
      delete(ss,1,i);
      val(sp, TK.r, i);
      if i <> 0 then begin
	ParseError:=7;
	x:=x+i;
       end
      else begin
	symb := NUMSYM;
	x:=x+i;
      end
      end {koniec przetwarzania liczby}
    else if ch in ['A'..'Z','a'..'z','_'] then  begin
      if not start('OR',ORSYM) then
      if not start('AND',ANDSYM) then
      if not start('NOT',NOTSYM) then begin
	i:=1;
	while (ss[i] in ['A'..'Z','0'..'9','_']) and (i<=length(ss)) do
	   inc(i);
	sb := x;
	sl:=i-1;
	x:=x+sl;
	delete(ss,1,i-1);
	symb:=IDSYM;
      end;
      end {koniec przetwarzania identyfikatorow}
    else if ch='''' then begin {napis}
      delete(ss,1,1);
      x:=x+1;
      i:=pos('''',ss);
      if i=0 then begin
	ParseError:=5;
	x:=x+length(ss);
	symb:=BADSYM
       end
      else begin
	sb:=x;
	sl:=i-1;
	delete(ss,1,i);
	x:=x+i;
	symb:=STRINGSYM;
      end
     end {koniec przetwarzania napisu}
   else begin { inne znaki }
     case ch of {znaki inne}
      '+'     : symb := ADDSYM;
      '*'     : symb := MULSYM;
      '-'     : symb := SUBSYM;
      '/'     : symb := DIVSYM;
      '('     : symb := LPAREN;
      ')'     : symb := RPAREN;
      ','     : symb := COMMASYM;
      ':'     : if pos('-',ss)=2 then begin
	          delete(ss,1,1);
	          symb := ISSYM
	         end;
      '>'     : if pos('=',ss)=2 then begin
	          delete(ss,1,1);
	          symb := GESYM
	         end
	        else
	          symb:=GTSYM;
      '<'     : begin
	         if pos('=',ss)=2 then begin
	           delete(ss,1,1);
	           symb := LESYM
	          end
	         else if pos('>',ss)=2 then begin
	           delete(ss,1,1);
	           symb := NESYM
	          end
	         else
	           symb:=LTSYM;
	        end;
      '='     : symb:=EQUSYM;
	else begin
	  ParseError:=6;
	  exit
	end
      end; {case}
      if ParseError=0 then begin
	if symb in [LESYM, ISSYM, GESYM, NESYM] then begin
	  delete(ss,1,2);
	  x:=x+2
	 end
	else begin
	  x:=x+1;
	  delete(ss,1,1)
	end
      end
     end
   end
  end;
end; {NextToken}

end.

