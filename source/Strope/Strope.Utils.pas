unit Strope.Utils;

interface

uses
  Strope.Math;

function GetDesktopResolution: TVectorI;

implementation

uses
  Windows;

function GetDesktopResolution: TVectorI;
begin
  Result := Vec2I(GetSystemMetrics(SM_CXSCREEN), GetSystemMetrics(SM_CYSCREEN));
end;

end.
