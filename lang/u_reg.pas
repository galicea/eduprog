(*
* Tworzenie automatu dla analizy gramatyk regularnych
*
*
* wersja 1.01
* author: Jerzy Wawro
*
*	Copyright (c) 1991-2016, Galicea <fundacja@galicea.org>
*	All rights reserved.
*	License FreeBSD: see license.txt for details.
*)
unit u_reg;
interface

procedure reg_automat(reg, fn : string);

implementation
uses
  SysUtils;

type
  (* Automat niezdeterminowany *)
  wskTst = ^TStan;

  TStan = record
    NrSt: integer;
    nast: wskTst;
  end;
  wekt = array[1..100] of wskTst;
  wwsk = ^wekt;
  TStany = array[1..100] of record
    wfPrz: wwsk;
    K: boolean; (* koncowy ? *)
  end;

  TAutomat = record
    stany: TStany;
    StanPocz: integer;
    ilStan: integer; (* ilosc stanow *)
  end;

  (* Autiomat zdeterminowany *)
  WektZdet = array[1..40] of integer;
  StanyZdet = array[1..131] of record
    wfPrz: ^WektZdet;
    K: boolean;
  end;

  AutZdet = record
    stany: StanyZdet;
    StanPocz, IlStan: integer;
  end;
  AWsk = ^TAutomat;

var
  S: array[1..50] of record
    (* wyrazenie po zamianie na notacje beznawiasowa *)
    operator1: boolean;
    N: integer; (* numer smbolu terminalnego *)
    ZN: char;   (* operator1 *)
    aut: AWsk
  end;
  ws: integer;  (* wskazuje aktualny element tablicy 'S' *)
  termin: array[1..40] of char; (* tablica terminali *)
  ilTerm: integer; (*ilosc terminali *)
  AZ: AutZdet;
  W: TAutomat;
  wsk2: wskTst;

  ofile: Text;
  ofile_name: string[12];

procedure zamien(var SW: string);
(* zamienia wczytane wyrazenie na notacje beznawiasowa *)
(* oraz tworzy tablice symboli terminalnych *)
var
  StosDod: record (* pomocnicza struktura stosu *)
    SD: array [1..25] of char;
    w: integer; (* wierzcholek stosu *)
  end;
  term, nast, koniec: boolean;
  (* nast -wskazuje, czy ma BYc czytany nastpny znak *)
  (* term - wskazuje, czy ostatni znak BYl terminalem *)
  dod, x: char; (* x - aktualnie przetwarzany znak *)
  nTerm: array[#0..#255] of integer; (* numery terminali *)

  procedure blad(x: integer); (* sygnalizuje bledna postac wyrazenia *)
  begin
    writeln(ofile, 'blad numer ', x);
    HALT;
  end; (* blad *)

  procedure getch(var x: char);
  begin
    if SW = '' then
      x := '%'
    else begin
      x := SW[1];
      Delete(SW, 1, 1);
    end;
    Write(ofile, x);
  end; (* getch*)

  procedure OutOp(x: char); (* umieszcza operator1 w tablicy 'S' *)
  begin
    ws := ws + 1;
    S[ws].operator1 := True;
    S[ws].zn := x;
  end; (*Outop *)

  procedure powrot; (* ze stosu dodatkowego DO tablicy 'S' *)
  begin
    OutOp(StosDod.SD[StosDod.w]);
    nast := False; (* nie czytaj natepnego symbolu *)
    StosDod.w := StosDod.w - 1;
  end; (* powrot *)

  procedure NaDod(x: char); (* umieszcza na stosie operator1 *)
  begin
    with StosDod do begin
      w := w + 1;
      SD[w] := x;
    end;
  end; (* NaDood *)

  procedure OutArg(x: char);
  (* umieszcza argument w tablicy 'S' *)
  begin
    ws := ws + 1;
    (* ustalenie numeru terminala *)
    if nTerm[x] = 0 then begin (* nie ma go w tablicy terminali *)
      ilTerm := ilTerm + 1;
      termin[ilTerm] := x;
      nterm[x] := ilTerm;
      S[ws].N := ilTerm;
     end
    else
      s[ws].N := nTerm[x];
    S[ws].operator1 := False;
    term := True;
  end; (* OutArg *)

begin (* zamien *)
  for x := #0 to #255 do
    nTerm[x] := 0;
  koniec := False;
  term := False;
  ws := 0;
  ilTerm := 0;
  with StosDod do begin
    SD[1] := '%';
    w := 1; (* % = ogranicznik konca wyrazenia *)
  end;
  getch(x);
  repeat
    with StosDod do begin
      if x = '%' then begin
        nast := False;
        case SD[w] of
          '%': koniec := True;
          '|', '+': powrot;
          '(': blad(1)
        end;
       end
      else begin
        nast := True;
        if x = '|' then begin
          term := False;
          case SD[w] of
            '|', '+': powrot;
            '%', '(': naDod(x);
          end;
         end
        else if x = '@' then
          OutOp('*')
        else if x = '(' then begin
          getch(dod); (* sprawdz, czy nawias *)
          if dod = '&' then begin
            if term then begin
              NaDod('+');
              term := False;
            end;
            NaDod(x);
           end
          else begin
            OutArg(x);
            term := True;
            x := dod;
            nast := False;
          end;
         end
        else if x = '&' then begin (* sprawdz czy prawy nawias *)
          getch(dod);
          if dod = ')' then begin (* nawias *)
            while SD[w] <> '(' do
              if SD[w] = '%' then
                blad(2)
              else
                powrot;
            nast := True;
            w := w - 1;
           end
          else begin
            OutArg(x);
            term := True;
            x := dod;
            nast := False;
          end;
         end
        else begin
          if term then (* konkatenacja *)
            with StosDod do begin
              if SD[w] = '+' then
                powrot;
              NaDod('+');
              nast := True;
            end;
          OutArg(x);
          term := True;
        end;
      end;
    end; (* WITH *)
    if nast then
    begin
      getch(x);
    end
  until koniec;
end; (* zamiana *)


procedure AutoTer(var wElem: integer);
(* procedura tworzy automat dla pojedynczego elementu terminalnego *)
var
  akt: integer;
  automat: AWsk;
  fPrz: wwsk;
  wsk: wskTst;

  procedure ZerFPrz;
  (* zerowani funkcji przejscia *)
  (* procedura zeruje wektor DO ktorego odnosnik jest pod zmienna globalna fPrz *)
  var
    k: integer;
  begin
    for k := 1 to ilTerm do
      fPrz^[k] := nil;
  end; (*ZerFPrz*)

begin (*AutoTer*)
  akt := S[wElem].N; (*AKT - Numer terminala *)
  NEW(automat);
  S[wElem].aut := automat;
  with automat^ do  begin (* tworzenie pierwszego stanu *)
    stany[1].k := False;
    StanPocz := 1;
    NEW(fPrz);
    ZerFPrz;
    NEW(wsk);
    wsk^.nast := nil;
    wsk^.nrSt := 2;
    fPrz^[akt] := wsk;
    stany[1].wFPrz := fPrz;
    (* tworzenie drugiego stanu *)
    stany[2].k := True;
    NEW(fPrz);
    ZerFPrz;
    stany[2].wFPrz := fPrz;
    ilStan := 2;
  end;
end; (* Autoter *)

procedure KopList(var wsk1, w: wskTst);
(* kopiuje liste zaczynajaca sie od w *)
(* jako wynik otrzymujemy odsylacz do listy pod zmienna wsk2^.nast
   UWAGA - procedura dziala na zmiennej globalnej wsk2 pod ktora
   jako efekt uboczny znajduje sie wskaznik do ostatniego elementu listy *)

var
  wsk: wskTst;
begin
  wsk := w;
  NEW(wsk1);
  wsk2 := wsk1;
  while wsk <> nil do begin
    NEW(wsk2^.nast);
    wsk2 := wsk2^.nast;
    wsk2^.nrSt := wsk^.nrSt;
    wsk := wsk^.nast;
  end;
  wsk2^.nast := nil;
end; (*KopList *)

procedure uzupelnij(var G, F: wekt);
(* procedura uzupelnia funkcje przejscia G@ stanami funkcji przejscia F@ *)
(* dla odpowiednich terminali *)
var
  l: integer;
  wsk, wsk1, wsk3: wskTst;

begin
  for l := 1 to IlTerm do begin
    kopList(wsk3, F[l]);
    if G[l] <> nil then begin
      wsk1 := G[l];
      repeat
        wsk := wsk1;
        wsk1 := wsk1^.nast;
      until wsk1 = nil;
      wsk^.nast := wsk3^.nast;
     end
    else
      G[l] := wsk3^.nast;
  end;
end; (*uzupelnij *)

procedure przenumeruj(A: TStany; odNr, doNr: integer);
(* powieksza numery stanow dodanych dla uzyskania jednoznacznosci *)
var
  i, j: integer;
  wsk: wskTst;

begin
  for i := odNr + 1 to doNr do
    for j := 1 to ilTerm do begin
      wsk := A[i].wfPrz^[j];
      while wsk <> nil do begin
        wsk^.nrst := wsk^.nrst + odNr;
        wsk := wsk^.nast;
      end;
    end;
end; (* przenumeruj *)

procedure gwiazdka(welold, welem: integer);
(* tworzy automat dla wyrazenia A@
   welold - wskazuje automat A;
   welem - wskazuje operator1 *)

var
  l: integer;
  fPrz: wwsk;
  wsk1: wskTst;

begin
  S[welem].aut := S[welold].aut; (* podstawienie automatu wyrazenia R do
                           automatu wyrazenia wynikowego *)
  with S[welem].aut^ do begin
    for l := 1 to ilStan do begin
      if stany[l].K then
        uzupelnij(stany[l].wfprz^, stany[stanpocz].wfPrz^);
    end;
    ilStan := ilStan + 1;
    NEW(fprz);
    stany[ilStan].wfPrz := fPrz;
    for l := 1 to ilTerm do begin
      kopList(wsk1, stany[StanPocz].wfPrz^[l]);
      stany[ilStan].wfPrz^[l] := wsk1^.nast;
    end;
    stany[ilStan].K := True;
    stanPocz := ilStan;
  end;
end; (* gwiazdka *)

procedure konkatenacja(welold, welnew, welem: integer);
(* tworzy automat dla wyrazenia typu RS
   welold - indeks wyazenia R;
   welnew - indeks wyrazenia S;
   welem - indeks operator1a *)
var
  i, lk, l: integer;
  wsk, wsk1: wskTst;
  AT: AWsk;
  A, B: wekt;

begin
  S[welem].aut := S[welold].aut;
  AT := S[welnew].aut;
  with S[welem].aut^ do begin
    for l := ilStan + 1 to ilStan + AT^.ilStan do begin
      lk := l - ilStan;
      stany[l] := AT^.stany[lk];
    end;
    przenumeruj(stany, ilStan, ilStan + AT^.ilStan);
    for l := 1 to ilStan do
      if stany[l].K then begin
        A := stany[l].wfPrz^;
        B := AT^.stany[AT^.stanPocz].wfPrz^;
        for i := 1 to IlTerm do begin
          kopList(wsk1, B[i]);
          if A[i] <> nil then begin
            wsk2 := A[i];
            repeat
              wsk := wsk2;
              wsk2 := wsk2^.nast;
            until wsk2 = nil;
            wsk^.nast := wsk1^.nast;
           end
          else
            A[i] := wsk1^.nast;
        end;
        stany[l].wfPrz^ := A;
      end;
    if not AT^.stany[AT^.stanPocz].K then
      for i := 1 to ilStan do
        stany[l].k := False;
    ilStan := ilStan + AT^.ilStan;
  end;
end; (* konkatenacja *)

procedure suma(welold, welem, welnew: integer);
(* realizuje automat dla wyrazenia R|S
   parametry jak dla procedury konkatenacja *)

var
  AT: AWsk;
  i, l, lk: integer;
  fPrz: wwsk;
  wsk1, wsk3: wskTst;

begin
  S[welem].aut := S[welold].aut;
  AT := S[welnew].aut;
  with S[welem].aut^ do begin
    for l := ilStan + 1 to ilStan + AT^.ilStan do begin
      lk := l - ilStan;
      stany[l] := AT^.stany[lk];
    end;
    przenumeruj(stany, ilStan, ilStan + AT^.ilStan);
    ilStan := ilStan + AT^.ilStan + 1;
    if stany[stanPocz].K or (AT^.stany[AT^.stanPocz].K) then
      stany[ilStan].K := True
    else
      stany[ilStan].K := False;
    NEW(fPrz);
    stany[ilStan].wfPrz := fPrz;
    (* kopiowanie funkcji przejscia *)
    for i := 1 to ilTerm do begin
      with stany[stanPocz] do begin
        kopList(wsk1, wfPrz^[i]);
        fPrz^[i] := wsk1^.nast;
      end;
      with AT^.stany[AT^.stanPocz] do
        if wsk1^.nast <> nil then begin
          wsk3 := wsk2; (* jako skutek uboczny dzialania procedury kopList
                   wsk2 zawiera wskaznik DO ostatniego elementu listy *)
          kopList(wsk1, wfPrz^[i]);
          wsk3^.nast := wsk1^.nast;
         end
        else begin
          kopList(wsk1, wfPrz^[i]);
          fPrz^[i] := wsk1^.nast;
        end;
    end;
  end;
  S[welem].aut^.stanPocz := S[welem].aut^.ilStan;
end; (* suma *)

procedure determ(var A: TStany; var Z: StanyZdet;
  var ilNowa: integer; ilTerm, StanPocz: integer);
(* procedura zmienia automat niezdeterminowany na zdeterminowany *)
(* usuwa jednoczesnie stany nieosiagalne *)

(* ilNowa - nowa ilosc stanow; Z - tablica przejsc nowego automatu *)

type
  T = array[1..31] of integer;

var
  NrNowy, TP: T; (*NrNowy[i] - stan o nowym numerze = i *)
  (* NrNowy odwzorowuje zbiory stanow na numery w automacie zdeterminowanym *)
  (* TP zawiera numery stanow DO ktorych mozna przejsc od nowego stanu *)

  l, m: integer;
  kn: boolean;
  wsk: wskTst;

  function dwaDo(i: integer): integer;
  var
    N, J: integer;
  begin
    N := 2;
    for j := 1 to i do
      N := N * 2;
    dwaDo := N;
  end; (* dwaDo *)

  function JestWTab(m, il: integer; var TP: T; var l: integer): boolean;
    (*sprawdza czy w tablicy TP jests element m *)
    (* l - indeks znalezionego elementu *)

  var
    b: boolean;

  begin
    l := 0;
    b := True;
    while (l < il) and b do begin
      l := l + 1;
      if TP[l] = m then
        b := False;
    end;
    JestWTab := not b;
  end; (* JestWTab *)

  procedure P(var TPST: T; ilTPST: integer; konc: boolean);
(* tworzy jeden stan; TPST zawiera stany z ktorych bedzie tworzony,
   ilTPST - ilosc tych stanow, konc - czy stan bedzie koncowy *)

  var
    TPNW: T; (* dokad mozna przejsc z tego stanu przy danym terminalu;
        ilosc wskazuje ilTPNW *)
    st, ilTPNW: integer; (* st - numer tworzonego stanu *)
    i, j: integer;

  begin
    st := ilNowa;
    (* utworzenie stanu *)
    with Z[ilNowa] do begin
      NEW(wfPrz);
      K := konc;
    end;
    for i := 1 to ilTerm do begin (* znalezienie przejsc dla tego stanu *)
      ilTPNW := 0;
      KN := False;
      for j := 1 to ilTPST do begin
        wsk := A[TPST[j]].wfPrz^[i];
        while wsk <> nil do begin
          m := wsk^.nrSt;
          if not JestWTab(M, ilTPNW, TPNW, l) then begin
            ilTPNW := ilTPNW + 1;
            if A[m].K then
              KN := True;
            TPNW[ilTPNW] := m;
          end;
          wsk := wsk^.nast;
        end;
      end;
      if ilTPNW <> 0 then begin
        (* mozna wyjsc z tego stanu przy tym terminalu *)
        (* tworzenie jednoznacznego numeru dla zbioru stanow *)
        m := 0;
        for j := 1 to ilTPNW do
          m := m + dwaDo(TPNW[j]);
        (* sprawdzenie, czy ten stan juz jest *)
        if JestWTab(m, ilNowa, nrNowy, l) then
          Z[st].wfPrz^[i] := l
        else begin (* tworzenie nowego stanu *)
          ilNowa := ilNowa + 1;
          nrNowy[ilNowa] := m;
          Z[st].wfPrz^[i] := ilNowa;
          P(TPNW, ilTPNW, KN);
        end;
       end
      else
        Z[st].wfPrz^[i] := 0; (* nie ma przejscia *)
    end;
  end; (*P*)

begin (* determ *)
  l := dwaDo(stanPocz);
  nrNowy[1] := l;
  ilnowa := 1;
  TP[1] := stanPocz;
  P(TP, 1, A[stanPocz].K);
end; (* determ *)

procedure redukcja(var A: StanyZdet; ilStan, ilTerm: integer; var ilNowa: integer);
(* procedura laczy stany nieroroznialne *)
type
  wskPZG = ^PZG;

  PZG = record
    warzg: array[1..2, 1..40] of integer;
    (* pary od ktorych zalezy zgodnosc pary (zg1, zg2) *)
    zg1, zg2: integer;
    il: integer;
    nstpar: wskPZG
  end;

var
  zamien, nrNowy: array [0..100] of integer;
  (* zamien - nowe numery stanow przed sciesnieniem;
  nrNowy - nowe numery stanow po sciesnieniu *)
  zgodne: array[1..100, 1..100] of boolean; (* macierz zgodnosci *)

  wskAkt, wskPoprz, listaZg: wskPZG;
  n, i, j, k, l: integer;
  nzg: boolean;
  znika: array [1..100] of boolean;

begin
  (* ustawienie pierwotnej macierzy zgodnosci *)
  for i := 1 to ilStan do
    if A[i].K then
      for j := 1 to ilStan do
        zgodne[i, j] := A[j].K
    else
      for j := 1 to ilStan do
        zgodne[i, j] := not A[j].K;
  (* wypisanie wszystkich par zgodnych, ustalenie warunkow zgodnosci *)
  NEW(listaZg);
  wskPoprz := listaZg;
  for i := 2 to ilStan do (* kazda para sprawdzana tylko raz *)
    for j := 1 to i - 1 do
      if zgodne[i, j] then
      begin (* ustalenie warunkow zgodnosci *)
        NEW(wskAkt);
        with wskAkt^ do begin
          zg1 := i;
          zg2 := j;
          l := 1; (* aktualna ilosc par wpisana w warZg *)
          for k := 1 to ilTerm do
            if A[i].wfPrz^[k] <> A[j].wfPrz^[k] then begin
              warzg[1, l] := A[i].wfPrz^[k];
              warzg[2, l] := A[j].wfPrz^[k];
              l := l + 1;
            end;
          il := l - 1;
        end;
        wskPoprz^.nstPar := wskAkt;
        wskPoprz := wskAkt;
      end;
  wskPoprz^.nstpar := nil;
  (* badanie, czy spelnione sa warunki zgodnosci -
     ewentualne skreslenie pary z listy *)
  (* N - stopien nierozroznialnosci *)
  N := 2;
  wskAkt := listaZg^.nstpar;
  wskPoprz := listaZg;
  repeat
    while wskAkt <> nil do
      with wskAkt^ do
      begin
        i := 1;
        nzg := False;
        while (i <= il) and (not nzg) do begin
          j := warZg[1, i];
          k := warzg[2, i];
          if (j = 0) or (k = 0) then
            nzg := j <> k
          else
            nzg := not zgodne[j, k];
          i := i + 1;
        end;
        if nzg then
        begin
          zgodne[zg1, zg2] := False;
          zgodne[zg2, zg1] := False;
          wskAkt := wskAkt^.nstPar;
          wskPoprz^.nstPar := wskAkt;
        end
        else
        begin
          wskPoprz := wskAkt;
          wskAkt := wskAkt^.nstPar;
        end;
        N := N + 1;
      end
  until (N >= ilStan);

  (*laczenie stanow *)
  for i := 1 to ilStan do (* wstepne ustalenie zamiennikow *)
    zamien[i] := i;
  (* stan pierwszy z pary zgodnej bedzie przyjmowac nazwemlodszego *)
  wskAkt := listaZg^.nstPar;
  while wskAkt <> nil do
  begin
    with wskAkt^ do
      if zg1 > zg2 then
        zamien[zg1] := zamien[zg2]
      else
        zamien[zg2] := zamien[zg1];
    wskAkt := wskAkt^.nstPar;
  end;

  (* sciesnienie stanow, wyznaczenie nowej liczby stanow *)
  j := 0;
  nrNowy[0] := 0;
  for i := 1 to ilStan do
    znika[i] := False;
  for i := 1 to ilStan do
    if zamien[i] <> i then
    begin
      znika[i] := True;
      j := j + 1;
      k := zamien[i];
      while zamien[k] <> k do
        k := zamien[k];
      nrNowy[i] := k;
    end
    else
      nrNowy[i] := zamien[i] - j;

  (* przenumerowanie stanow *)
  for i := 1 to ilStan do
    if not znika[i] then
    begin
      k := nrNowy[i];
      A[k] := A[i];
      for k := 1 to ilTerm do
      begin
        l := A[i].wfPrz^[k];
        A[i].wfPrz^[k] := nrNowy[l];
      end;
    end;
  ilNowa := ilStan - j;
end; (* redukcja *)

procedure DrkNzd(var A: TAutomat);
var
  i, j, k, l, ilk: integer;
  konc: array[1..32] of integer;
  wsk: wskTst;

begin
  with A do
  begin
    writeln(ofile);
    writeln(ofile, 'stan poczatkowy : ', stanPocz);
    writeln(ofile, 'ilosc stanow    : ', ilStan);
    writeln(ofile, 'zbior symboli terminalnych');
    for i := 1 to ilTerm do
      Write(ofile, '   ', termin[i]);
    writeln(ofile);
    writeln(ofile);
    writeln(ofile, 'tabela przejsc:');
    Write(ofile, '          ');
    for i := 1 to ilTerm do
      Write(ofile, termin[i]: 2, '                ');
    writeln(ofile);
    for j := 1 to ilTerm * 16 + 4 do
      Write(ofile, '-');
    writeln(ofile);
    ilk := 0;
    for i := 1 to ilStan do
    begin
      if stany[i].K then
      begin
        ilk := ilk + 1;
        konc[ilk] := i;
      end;
      if i < 10 then
        Write(ofile, i: 2, ' |')
      else
        Write(ofile, i: 3, '|');
      for j := 1 to ilTerm do
      begin
        wsk := stany[i].wfPrz^[j];
        k := 1;
        while wsk <> nil do
        begin
          Write(ofile, wsk^.nrSt: 3);
          k := k + 1;
          wsk := wsk^.nast;
        end;
        for l := k to 5 do
          Write(ofile, '   ');
        Write(ofile, '|');
      end;
      writeln(ofile);
      for j := 1 to ilTerm * 16 + 4 do
        Write(ofile, '-');
      writeln(ofile);
    end;
    writeln(ofile, 'stany koncowe: ');
    for i := 1 to ilk do
      Write(ofile, konc[i], ' ');
    writeln(ofile);
  end;
end; (*DrNzd *)

procedure DrkZd(var A: AutZdet);
var
  i, j, ilk: integer;
  konc: array[1..32] of integer;

begin
  with A do
  begin
    writeln(ofile, 'stan poczatkowy : ', stanPocz);
    writeln(ofile, 'ilosc stanow    : ', ilStan);
    writeln(ofile, 'zbior symboli terminalnych');
    for i := 1 to ilTerm do
      Write(ofile, '  ', termin[i]);
    writeln(ofile);
    writeln(ofile);
    writeln(ofile, 'tabela przejsc:');
    Write(ofile, '       ');
    for i := 1 to ilTerm do
      Write(ofile, termin[i], '   ');
    writeln(ofile);
    for j := 1 to ilTerm * 6 + 2 do
      Write(ofile, '-');
    writeln(ofile);
    ilk := 0;
    for i := 1 to ilStan do
    begin
      if stany[i].K then
      begin
        ilk := ilk + 1;
        konc[ilk] := i;
      end;
      if i < 10 then
        Write(ofile, i: 2, '   |')
      else
        Write(ofile, i: 3, '|');
      for j := 1 to ilTerm do
      begin
        Write(ofile, stany[i].wfPrz^[j]: 3);
        Write(ofile, '|');
      end;
      writeln(ofile);
      for j := 1 to ilTerm * 6 + 2 do
        Write(ofile, '-');
      writeln(ofile);
    end;
    writeln(ofile, 'stany koncowe: ');
    for i := 1 to ilk do
      Write(ofile, konc[i]);
    writeln(ofile);
  end;
end; (*DrkZd *)

var
  i, j, l, licz: integer;

procedure pauza;
begin
  if ofile_name = '' then  begin
    Write('nacisnij <Enter> ');
    readln;
    writeln;
  end;
end;

procedure reg_automat(reg, fn : string);
begin
  ofile_name:=fn;
  Assign(ofile, fn);
  rewrite(ofile);
  zamien(reg); (* zamiana  na notacje beznawiasowa *)
  writeln(ofile);
  writeln(ofile, 'wyrazenie po zamianie na notacje beznawiasowa : ');
  for i := 1 to ws do
    with S[i] do
      if operator1 then
        Write(ofile, zn)
      else
        Write(ofile, N: 2);
  writeln(ofile);
  writeln(ofile, 'tablica terminali: ');
  for i := 1 to ilTerm do
    writeln(ofile, ' ', i, ' ', termin[i]);
  pauza;
  (*zamiana wyrazenia na automat *)
  l := 1;
  repeat
    if not S[L].operator1 then
      autoter(l);
    l := l + 1;
  until L = ws;
  l := 0;
  repeat
    repeat
      l := l + 1
    until S[l].operator1;
    case S[l].zn of
      '+': konkatenacja(l - 2, l - 1, l);
      '|': suma(L - 2, L, L - 1);
      '*': gwiazdka(L - 1, L)
    end;
    S[L].operator1 := False;
    (*przesuniecie reszty w tablicy *)
    if S[L].zn = '*' then
      j := 1
    else
      j := 2; (* j = wielkosc przesuniecia *)
    licz := l - j - 1;
    while licz > 0 do
    begin
      S[licz + j].aut := S[licz].aut;
      licz := licz - 1;
    end;
  until L = ws; (* ws wskazuje ostatni element w S *)
  (* wydruk wynikow *)
  writeln(ofile);
  writeln(ofile, 'Automat niezdeterminowany:');
  w := S[ws].aut^;
  drkNZd(w);
  pauza;
  determ(w.stany, az.stany, az.ilStan, ilterm, w.StanPocz);
  AZ.StanPocz := 1;
  writeln(ofile);
  writeln(ofile, 'Automat po determinacji');
  DrkZd(AZ);
  pauza;
  redukcja(AZ.stany, AZ.ilStan, ilTerm, AZ.ilStan);
  writeln(ofile);
  writeln(ofile, 'Automat po redukcji:');
  drkZd(AZ);
  Close(ofile);
end;

end.
