unit uMain;

interface

procedure InitializeApplication;
procedure StartApplication;
procedure StopApplication;
procedure DestroyApplication;

implementation

uses
  SysUtils,
  QEngine.Core,
  QApplication.Application,
  Project87.Game,
  Strope.Math;

procedure InitializeApplication;
var
  AParameters: TQApplicationParameters;
begin
  CreateEngine(TVectorI.Create(1024, 768), TVectorI.Create(1024, 600));

  AParameters := TQApplicationParameters.Create(
    TProject87Game.Create, TheEngine.CurrentResolution, False, 10);
  TheApplication.OnInitialize(AParameters);
end;

procedure StartApplication;
begin
  TheApplication.OnActivate(True);
  TheApplication.Loop;
end;

procedure StopApplication;
begin
  TheApplication.OnDestroy;
end;

procedure DestroyApplication;
begin
  TheEngine := nil;
end;

end.
