{ Szkielet programu dla analizatora gramatyk LR1.                      }
{ W instrukcji $I kompilatora nalezy umiescic nazwe pliku w ktorym     }
{ zapisano wynik pracy generatora.                                     }
{ Aby uzyskac program uzytkowy nalezy w procedurze Redukcja umiescic   }
{ generacje kodu, lub obliczenia. Dodatkowo mozna wykorzystac zmienn†  }
{ ParseError do analizy beedow                                         }

{ wersja 1.0     J. Wawro }

uses Crt, Dos,
     Tscan;

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

procedure Push(TK : Token);
{ Token na stos }
begin
  if StackTop = StackSize then begin
    writeln('Za maey stos !');
    blad := TRUE;
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
{$I WYNIK.LR1}

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
  if blad then
    writeln('Be†d')
  else
    writeln('Wyrazenie poprawne');
end.
