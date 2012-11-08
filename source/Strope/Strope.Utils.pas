unit Strope.Utils;

interface

uses
  Strope.Math,
  Windows;

function GetDesktopResolution: TVector2I;

implementation

function GetDesktopResolution: TVector2I;
begin
  Result := TVector2I.Create(GetSystemMetrics(SM_CXSCREEN), GetSystemMetrics(SM_CYSCREEN));
end;

end.
