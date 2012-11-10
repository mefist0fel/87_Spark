unit Strope.Utils;

interface

uses
  Strope.Math;

function GetDesktopResolution: TVector2I;

implementation

uses
  Windows;

function GetDesktopResolution: TVector2I;
begin
  Result := Vec2I(GetSystemMetrics(SM_CXSCREEN), GetSystemMetrics(SM_CYSCREEN));
end;

end.
