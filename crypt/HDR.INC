{$IFDEF WIN32}
  {$DEFINE DELPHI2}
  {$DEFINE WINDOWS}
{$ELSE}
  {$IFDEF WINDOWS}
    {$DEFINE DELPHI1}
  {$ELSE}
    {$IFDEF FPC}
      {$DEFINE CONSOLE}
    {$ELSE}
      {$DEFINE DOS}
      {$DEFINE CONSOLE}
      {$DEFINE MOUSE}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
{$IFDEF DOS}
{$F+,O+,R-,B-,V-}
{$ELSE}
{$IFDEF FPC}
{$R-,D-,H-,V-}
{$ELSE}
{$R-,A-,H-,J+,Z-,B-,V-,O+,F+}
{$ENDIF}
{$ENDIF}

