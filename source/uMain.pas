unit uMain;

interface

procedure InitializeApplication;
procedure StartApplication;
procedure DestroyApplication;

implementation

uses
  SysUtils,
  Strope.Utils,
  QEngine.Core,
  QApplication.Application,
  QGame.Game,
  Project87.Game,
  Strope.Math;

procedure InitializeApplication;
var
  AParameters: TQApplicationParameters;
begin
  Randomize;

  CreateEngine(TVectorI.Create(1024, 768), TVectorI.Create(1280, 720));
  //CreateEngine(TVectorI.Create(1024, 768), GetDesktopResolution);

  TheApplication := TQApplication.Create;
  AParameters := TQApplicationParameters.Create(
    TProject87Game.Create, TheEngine.CurrentResolution, False, 10);
  TheApplication.OnInitialize(AParameters);
end;

procedure StartApplication;
begin
  TheApplication.OnActivate(True);
  TheApplication.Loop;
end;

procedure DestroyApplication;
begin
  TheApplication.Free;
  TheEngine.Free;
end;

end.
