(*
* Tworzenie automatu dla analizy gramatyk LR(1)
*
*
* wersja 1.01
* author: Jerzy Wawro
*
*	Copyright (c) 1991-2016, Galicea <fundacja@galicea.org>
*	All rights reserved.
*	License FreeBSD: see license.txt for details.
*)
unit u_makelr1;
interface

procedure lr1(fnin, fnout : string);

implementation
uses Dos;
{$R+}

{* $DEFINE TEST}

{$IFDEF TEST}
const
 maxIlTokenow = 50;
 maxIlProd    = 50;
 maxIlStanow  = 100;
{$ELSE}
const
 maxIlTokenow = 100;
 maxIlProd    = 100;
 maxIlStanow  = 175;
{$ENDIF}

type

 token = record
   symbol : string[24];
   terminalny : boolean
  end;

 tokeny = array[0..maxIlTokenow] of token;

 ciagTokenow = array[1..13] of byte;

 produkcja = record
   lewy  : byte;
   ilPrawych : byte;
   prawe : ciagTokenow;
   ps : string[50]
 end;

 produkcje = array[1..maxIlProd] of produkcja;

 stan = record
	  ilT : byte;
	  T   : ciagTokenow
	end;

 stany = array [0..maxIlStanow] of stan;

 automat = array [0..maxIlStanow, 0..maxIlTokenow] of integer;
   { liczba dodatnia oznacza nastepny stan przy akceptacji }
   { liczba ujemna oznacza numer redukcji do wykonania     }
   { 0 oznacza bíad }

 PrzejsciePoRedukcji = array[1..maxIlProd, 0..maxIlStanow] of byte;

 WywodLewostronny = array [1..maxIlTokenow,1..maxIlTokenow] of boolean;

var
 TK : tokeny;
 ilTK : word;
 PR : produkcje;
 ilPR : word;
 ST   : stany;
 ilST : word;
 tin, tout : text;
 A  : ^automat;
 PPR : PrzejsciePoRedukcji;
 WL :^WywodLewostronny;

procedure message(m : string);
begin
 writeln(m);
end;

procedure AnalizujProd(s :string);

var
 i : word;

 procedure awaria;
 begin
   writeln('Nieprawidlowa produkcja : ',PR[ilPR].ps);
   writeln;
   halt
 end; {awaria}

 procedure trim(var s  : string);
 var
   i : integer;
 begin
  i:=length(s);
  while (i>0) and (s[i]=' ') do i:=i-1;
  if i<=0 then
    s:=''
  else
    s:=copy(s,1,i);
 end;

 function UstalNumer(s : string) : word;
 var
  i : word;
 begin
  trim(s);
  i:=1;
  while i<=ilTK do begin
    if TK[i].symbol=s then begin
       UstalNumer:=i;
       exit
    end;
    i:=i+1;
  end;
  ilTK:=i;
  TK[i].symbol:=s;
  TK[i].terminalny:=s[1]<>'<';
  UstalNumer:=i;
end; {UstalNumer}

begin {AnalizujProd}
 if s='' then exit;
 i:=pos('::=',s);
 if i=0 then
   awaria;
 ilPR:=ilPR+1;
 with PR[ilPR] do begin
   ps:=s;
   lewy:=UstalNumer(copy(s,1,i-1));
   ilPrawych := 0;
   delete(s,1,i+2);
   while pos(' ',s)=1 do delete(s,1,1);
   repeat
     ilPrawych := ilPrawych+1;
     if s='' then awaria;
     if (s[1]='<') then begin
	i:=pos('>',s);
	if i=0 then awaria;
	prawe[ilPrawych]:=UstalNumer(copy(s,1,i));
       end
     else begin
       i:=2;
       while (i<=length(s)) and (s[i]<>' ') and (s[i]<>'<') do
	 i:=i+1;
       i:=i-1;
       prawe[ilPrawych]:=UstalNumer(copy(s,1,i));
     end;
     delete(s,1,i);
     while pos(' ',s)=1 do delete(s,1,1);
   until s='';
 end; {with}
end; {AnalizujProd}

procedure CzytajProd;
var
 s : string;
begin
 ilPR := 0;
 ilTK := 0;
 with TK[0] do begin
   symbol:='EOINSYM';
   terminalny:=TRUE
 end;
 write(' - czytanie produkcji ');
 writeln(tout,'(* produkcje:');
 while not eof(tin) do begin
   readln(tin,s);
   AnalizujProd(s);
   writeln(tout,ilPR,' :  ',s);
 end;
 writeln;
end; {CzytajProd}

procedure SpiszStany;
 var
  i, j, k : word;

 function rowne(i1,i2 : word) : boolean; {sprawdza rownosç stanow }
  var
   i : word;
  begin
    rowne:=FALSE;
    if ST[i1].ilT<>ST[i2].ilT then exit;
    for i:=1 to ST[i1].ilT do
      if (ST[i1].T[i]<>ST[i2].T[i]) then
	exit;
    rowne:=TRUE
 end; {rowne}

begin {SpiszStany}
 ilST:=0;
 ST[0].ilT:=0;
 write(' - ustalenie stanow');
 for i:=1 to ilPR do begin
   for j:=1 to PR[i].ilPrawych do begin
     ilST:=ilST+1;
     with ST[ilST] do begin
       ilT:=j;
       T:=PR[i].prawe
     end;
     k:=1;
     while k<ilST do
       if rowne(k,ilST) then begin
	 k:=ilST;
	 ilST:=ilST-1
	end
       else
	 k:=k+1;
   end;
 end;
 writeln(tout,'STANY : ');
 for i:=1 to ilST do begin
   write(tout,i,' :  ');
   for j:=1 to ST[i].ilT do
     write(tout,TK[ST[i].T[j]].symbol,' ');
   writeln(tout);
 end;
 writeln(tout,'*)');
 writeln
end; {SpiszStany}



procedure tworzAutomat;
var
 i, j : word;

 function NumerStanu(st1 : stan) : word;
 var
  i, j : word;
  rowny : boolean;
 begin
   i:=0;
   rowny:=FALSE;
   while (i<=ilST) and (not rowny) do begin
     if ST[i].ilT=st1.ilT then begin
       rowny:=TRUE;
       j:=1;
       while (j<=st1.ilT) and rowny do begin
	 rowny:=st1.T[j]=ST[i].T[j];
	 j:=j+1
       end;
     end;
     i:=i+1;
   end;
   if rowny then
     NumerStanu:=i-1
   else
     NumerStanu:=0
 end; { NumerStanu }

 procedure konkatenacja(stan1 : stan; dod : word; var stan2 : stan);
 { dodaje do stanu stan1 token dod }
 begin
   stan2:=stan1;
   with stan2 do begin
     if ilT=maxIlTokenow then begin
       writeln('Gramatyka zbyt zlozona');
       halt
     end;
     inc(ilT);
     T[ilT]:=dod
   end
 end; { konkatenacja }

   function token2stan(t1 : word) : word;
   { zamienia token na stan }
   var
    s : stan;
   begin
     with s do begin
       ilT:=1;
       T[1]:=t1
     end;
     token2stan:=NumerStanu(s)
   end; {token2stan}


procedure TworzWL;
var
 i, j, k : word;
  saZmiany : boolean;
begin
 new(WL);
 for i:=1 to ilTK do
   for j:=1 to ilTK do
     WL^[i,j]:=FALSE;
 for i:=1 to ilPR do
      WL^[PR[i].lewy,PR[i].prawe[1]]:=TRUE;
 repeat
   saZmiany := FALSE;
   for i:=1 to ilTK do
     for j:=1 to ilTK do
       if WL^[i,j] then
	 for k:=1 to IlTK do
	   if WL^[j,k] and (not WL^[i,k]) then begin
	     saZmiany:=TRUE;
	     WL^[i,k]:=TRUE
	   end
 until not saZmiany
end; {TworzWL}


   function MoznaWywiescLewostronnie(z : word; t : word) : boolean;
   { sprawdza, czy mozna lewostronnie wywiesç z symbolu z token t }
   begin
     if z=t then begin
       MoznaWywiescLewostronnie:=TRUE;
       exit
     end;
     MoznaWywiescLewostronnie:=WL^[z,t]
   end; { MoznaWywiescLewostronnie }

   procedure WezOgon(var st : stan);
   var i : word;
   begin
     for i:=1 to st.ilT-1 do
       st.T[i]:=st.T[i+1];
     dec(st.ilT)
   end; {WezOgon }


procedure przesuniecia;
var
 stp : stan;
 i, j, m, n : word;


begin { przesuniecia }
  write(' - ustalenie przesunieç');
  for i:=0 to ilST do begin
    write('.');
    for j:=1 to IlTK do if  TK[j].terminalny then begin
      if (A^[i,j]<>0) then begin
	message('To nie jest gramatyka LR1');
	writeln('Niekreslone przejscie przy stanie ',i,' token ',TK[j].symbol);
	close(tin);
	halt
      end;
	{ nie ma sasiedniego stanu w ramach tej samej produkcji - sprawdzenie,
	  czy tego symbolu nie mozna wywiesç lewostronnie z symbolu,
	  ktory z kolei mozna dolaczyç }
      konkatenacja(ST[i],j,stp); { proba dolaczenia symbolu }
      repeat
	n := NumerStanu(stp); { jesli otrzymujemy nastepny stan - przejscie }
	wezOgon(stp)
      until (n<>0) or (stp.ilT<2);
      if n=0 then begin { nie ma takiego stanu - sprawdzenie,
	                  czy tego symbolu nie mozna wywiesç lewostronnie
	                  z symbolu, ktory z kolei mozna dolaczyç }
	m:=ilTK;
	while (m>=1) and (n=0) do begin
	  if MoznaWywiescLewostronnie(m,j) then begin
	    konkatenacja(ST[i],m,stp);
	    repeat
	      n := NumerStanu(stp);
	      wezOgon(stp)
	    until (n<>0) or (stp.ilT<2);
	    if n<>0 then
	       n := token2stan(j)
	  end;
	  m:=m-1
	end;
      end; { proba wywiedzenia }
      if n<>0 then
	  A^[i,j] := n
    end; { for }
  end;
  writeln;
end; {przesuniecia}

procedure redukcje;

var
 i, j, r : word;

 procedure ZnajdzProdukcje(s : word; var r : word);
   { sprawdza, czy ogon stanu st jest prawa strona ktorejs produkcji }
   { jesli tak - obcina ten ogon i zwraca numer produkcji }
   { szuka najdluzszego ogona }
   { zwraca: r - numer produkcji }
   var
    i, j, k, l : word;
    zgodne : boolean;
    stp, stp1 : stan;

 begin
  stp:=ST[s];
  l:=99;
  r:=0;
  for i:=1 to ilPR do begin
    j:=PR[i].ilPrawych; k:=stp.ilT;
    zgodne:=TRUE;
    while (j>0) and (k>0) and zgodne do begin
{???}
      zgodne:=PR[i].prawe[j]=stp.T[k];
      j:=j-1;
      k:=k-1
    end;
    if (zgodne) and (k<l) and (j=0) then begin
      stp1:=stp;
      stp1.ilT:=k;
      konkatenacja(stp1,PR[i].lewy,stp1);
      if NumerStanu(stp1)<>0 then begin
	l:=k;
	r:=i;
      end
    end
  end;
 end; {ZnajdzProdukcje}


begin { redukcje }
  write(' - redukcje ');
  for i:=1 to ilST do begin
    ZnajdzProdukcje(i,r);
    write('.');
    if r<>0 then begin
      for j:=0 to IlTK do
	if (A^[i,j]=0) then
	  A^[i,j]:=-r
    end;
  end;
  writeln
end; { redukcje }

procedure Przejscia;
var
 i, j, n : word;
 stp : stan;

begin
  write(' - przejscia po redukcji ');
  for i:=1 to ilPR do
    for j:=0 to ilST do
       PPR[i,j]:=0;
  for i:=1 to ilPR do begin
    write('.');
    for j:=0 to ilST do if (A^[j,PR[i].prawe[1]]>0) or
	(not TK[PR[i].prawe[1]].terminalny) then begin { jesli wogole moze sie pojawiç }
      konkatenacja(ST[j],PR[i].lewy,stp);
      n:=NumerStanu(stp);
      if n<>0 then
	PPR[i,j]:=n
      else
	PPR[i,j]:=token2stan(PR[i].lewy);
    end;
  end;
  writeln
end; { Przejscia }

begin {tworzAutomat}
  TworzWL;
  for i:=0 to ilST do
    for j:=0 to maxIlTokenow do
      A^[i,j]:=0;
  przesuniecia;
  redukcje;
  przejscia
end; { TworzAutomat }


procedure DrukujAutomat;

 procedure PoRedukcji;
 { tworzy procedure przejscia do nastepnego stanu po redukcji }
 var
   jest : boolean;
   i, j, k : word;
   drukowany : array[1..maxIlProd] of boolean;

  function rowne(i1, i2 : word) : boolean;
  var i : word;
      r : boolean;
  begin
    i:=0;
    r:=TRUE;
    while (i<ilST) and r do begin
      r:=PPR[i1,i]=PPR[i2,i];
      i:=i+1
    end;
    rowne:=r
  end; {rowne}

 begin
  writeln(tout);
  writeln(tout,'function PoRedukcji(produkcja : word) : word;');
  writeln(tout,'var');
  writeln(tout,' st : byte;');
  writeln(tout,'begin');
  writeln(tout,' st := AktualnyStan;');
  writeln(tout,' case produkcja of');
  for i:=1 to ilPR do
     drukowany[i]:=FALSE;
  for i:=1 to ilPR do begin
    j:=0; jest:=FALSE;
    while (j<=ilST) and (not jest) do begin
      jest:=jest or (PPR[i,j]<>0);
      j:=j+1;
    end;
    if jest and (not  drukowany[i]) then begin
      drukowany[i]:=TRUE;
      write(tout,'   ',i);
      for j:=i+1 to ilPR do
       if rowne(i,j) then begin
	  drukowany[j]:=TRUE;
	  write(tout,', ',j);
       end;
      writeln(tout,' : case st of');
      for j:=0 to ilST do
	if PPR[i,j]<>0 then begin
	  write(tout,'      ',j);
	  for k:=j+1 to ilST do
	    if PPR[i,j]=PPR[i,k] then begin
	      write(tout,', ',k);
	      PPR[i,k]:=0;
	    end;
	  writeln(tout,' : PoRedukcji := ',PPR[i,j],';');
	end;
      writeln(tout,'     end;');
    end;
  end;
  writeln(tout,' end; {case produkcja} ');
  writeln(tout,'end; { PoRedukcji }');
  writeln(tout);
 end; {PoRedukcji}

 procedure redukcja;
  var
   i, j : word;
 begin
  writeln(tout);
  writeln(tout,'procedure redukcja(produkcja : word);');
  writeln(tout);
  writeln(tout,' var');
  writeln(tout,'   TK1 : token;');
  writeln(tout,'begin');
  writeln(tout,'  case produkcja of');
  writeln(tout,'   { zdjecie ze stosu elementow prawej strony produkcji, ');
  writeln(tout,'     wygenerowanie kodu, lub wykonanie obliczen }');
  for i:=1 to ilPR do begin
    writeln(tout,'   ',i,': begin  { ',PR[i].ps,' }');
    for j:=1 to PR[i].ilPrawych do
      writeln(tout,'       pop(TK1);');
    writeln(tout,'       end;');
  end;
  writeln(tout,'  end; { case }');
  writeln(tout,'  NowyStan(PoRedukcji(produkcja));');
  writeln(tout,'end; { Redukcja }')
 end; {redukcja}

 procedure parser;
  var
   i, j : word;
   aa : integer;
   rozneReakcje : boolean;
   drukowane : array[0..maxIlStanow] of boolean;


 function rowne (i1, i2 : word) : boolean;
   { jednakowe stany sa grupowane razem }
 var
  i : word;
 begin
    for i:=1 to ilTK do
      if (A^[i1,i]<>A^[i2,i]) then begin
	rowne:=FALSE;
	exit
      end;
    rowne:=TRUE
 end; {rowne}

 begin
  writeln(tout);
  writeln(tout,'procedure parser;');
  writeln(tout,'var');
  writeln(tout,'  st : word;');
  writeln(tout,'begin');
  writeln(tout,' NextToken(sin,TK,x,ParseError);');
  writeln(tout,' t:=TK.symb;');
  writeln(tout,' repeat');
  writeln(tout,'   st:=AktualnyStan;');
  writeln(tout,'   if (st=1) and (t=EOINSYM) then');
  writeln(tout,'       koniec:=TRUE else');
  writeln(tout,'   case st of');
  for i:=0 to ilSt do
    drukowane[i]:=FALSE;
  for i:=0 to ilSt do if (not drukowane[i]) then begin
    write(tout,'    ',i);
    for j:=i+1 to ilSt do
      if rowne(i,j) then begin
	write(tout,', ',j);
	drukowane[j]:=TRUE
      end;
    aa:=A^[i,0];
    rozneReakcje:=FALSE;
    j:=1;
    while (j<=ilTK) and (not rozneReakcje) do begin
      rozneReakcje:=TK[j].terminalny and (A^[i,j]<>aa);
      j:=j+1
    end;
    if rozneReakcje then begin
      writeln(tout,' : case t of');
      for j:=0 to ilTK do
	if (TK[j].terminalny) and (A^[i,j]<>0) then begin
	  write(tout,'     ',TK[j].symbol, ' : ');
	  if A^[i,j]>0 then
	    writeln(tout,' przesuniecie(',A^[i,j],');')
	  else
	   writeln(tout,' redukcja(',-A^[i,j],');')
	end;

      writeln(tout,'     else blad := TRUE');
      writeln(tout,'    end;')
     end
    else
      if A^[i,0]>0 then
	writeln(tout,': przesuniecie(',A^[i,0],');')
      else
	writeln(tout,' : redukcja(',-A^[i,0],');')
  end;
  writeln(tout,'   else blad := TRUE');
  writeln(tout,'  end; { case }');
  writeln(tout,' until koniec or blad;');
  writeln(tout,'end; { parser }');
 end; {parser}

begin {DrukujAutomat}
 write(' - zapis wynikow ');
 PoRedukcji;
 redukcja;
 parser;
 writeln;
end; {DrukujAutomat}

procedure lr1(fnin, fnout : string);
begin {main}
 new(A);
 assign(tin,fnin);
 reset(tin);
 assign(tout,fnout);
 rewrite(tout);
 CzytajProd;
 SpiszStany;
 TworzAutomat;
 DrukujAutomat;
 close(tin);
 close(tout);
end;

end.

