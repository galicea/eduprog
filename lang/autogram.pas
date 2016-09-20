(*
* Copyright (c) 2016, Galicea <fundacja@galicea.org>
* All rights reserved.
* License FreeBSD: see license.txt for details.
*
* To build binary: fpc autogram
*)
program autogram;


uses
  u_makelr1, 
  u_reg;

type
  TOper = (o_lr1, o_reg, o_none);

var
 oper : TOper;
 ipar, opar : string;

procedure WriteHelp;
begin
  writeln('Usage: autogram [function[][options]');
  writeln('functions:');
  writeln(' -h - help');
  writeln(' -a - automat for regular grammar');
  writeln(' -r - automat for LR(1) grammar');
  writeln('Options');
  writeln(' -i - input');
  writeln(' -o - output (file name) - optional');
  writeln('Input (-i):');
  writeln(' - file name (grammar) - for LR(1)');
  writeln(' - expression (for regular) - inside "":');
  writeln('    a..z, |, (&, &), @');
  writeln('    | = or');
  writeln('    (& = left bracket');
  writeln('    &) = right bracket');
  writeln('    @ = many');
end;


procedure ParseOptions;
var
 i : integer;
 sval : char;
 s : string;
 c : char;
begin
  oper:=o_none;
  ipar:='';
  opar:='';
  sval := '?';
  for i:=1 to ParamCount do begin
    writeln(ParamStr(i));
    s:=ParamStr(i);
    if s='-h' then begin
       WriteHelp;
       halt(1);
    end;
    if s='-a' then oper:=o_reg
    else if s='-r' then oper:=o_lr1
    else if s='-i' then sval:='i'
    else if s='-o' then sval:='o'
    else if sval='i' then begin
      if pos('"',s)=1 then
        ipar:=copy(s,2,length(s)-2)
      else
        ipar:=s;
      sval:='?';
     end
    else if sval='o' then begin
      opar:=s;
      sval:='?';
     end
    else begin
       WriteHelp;
       halt(1);
    end;
  end;
end;

begin
  ParseOptions;
  if oper=o_reg then begin
    if ipar<>'' then begin
      if opar='' then begin
        writeln('Wyjście na ekran. Do pliku mozesz skierowac opcja -o');
        write('Nacisnij Enter');readln;
      end;
      reg_automat(ipar, opar)
     end
    else begin
      writeln('Poprawnie: autogram -a -i <wyrazenie> [-o <plik wynikowy>]');
    end;
    Writeln('Zakonczono');
   end
  else if oper=o_lr1 then begin
    if ipar<>'' then
//       lr1(ipar,opar)
    else begin
      writeln('Poprawnie: autogram -r -i <plik wejsciowy> [-o <plik wynikowy>]');
    end;
    Writeln('Zakonczono');
   end
  else
    WriteHelp;
end.
