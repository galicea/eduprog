program reg;

uses
  u_reg;


var
 sReg, fn : string;

begin 
  if ParamCount > 0 then
    sReg := ParamStr(1)
  else  begin
    Write('wyrazenie regularne : ');
    readln(sReg);
  end;
  Write('Wyniki do pliku (Enter = na ekran): ');
  readln(fn);
  reg_automat(sReg, fn);
  Write('Zakonczono. Nacisnij <Enter> ');
  readln;
  writeln;
end.
