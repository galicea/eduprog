(*
* Tworzenie automatu dla analizy gramatyk LR(1)
*
*
* wersja 1.01
* author: Jerzy Wawro
*
*	Copyright (c) 2016, Galicea <fundacja@galicea.org>
*	All rights reserved.
*	License FreeBSD: see license.txt for details.
*)
uses u_makelr1;

var
 fnin, fnout : string;

begin {main}
 writeln('Generator analizatorow gramatyk LR(1)');
 writeln('(c) Galicea       Wersja 1.01');
 write('Gramatyka jest w pliku  : ');
 readln(fnin);
 write('Wyniki zapisac do pliku : ');
 readln(fnout);
 lr1(fnin,fnout);
 writeln('Zakonczono przetwarzanie');
 write('nacisnij Enter');readln;
end.

