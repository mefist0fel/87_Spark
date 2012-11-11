unit Project87.Scenes.StarMapScene;

interface

uses
  QCore.Input,
  QGame.Scene,
  Strope.Math,
  Project87.Types.StarMap;

type
  TStarMapScene = class sealed (TScene)
    strict private
      FMap: TStarMap;
    public
      constructor Create(const AName: string);
      destructor Destroy; override;

      procedure OnInitialize(APameter: TObject = nil); override;
      procedure OnDraw(const ALayer: Integer); override;
      procedure OnUpdate(const ADelta: Double); override;
      procedure OnDestroy; override;

      function OnMouseMove(const AMousePosition: TVectorF): Boolean; override;
      function OnMouseButtonUp(AButton: TMouseButton;
        const AMousePosition: TVectorF): Boolean; override;
      function OnKeyUp(AKey: TKeyButton): Boolean; override;
  end;

implementation

uses
  QuadEngine,
  QEngine.Core,
  QApplication.Application;

{$REGION '  TStarMapScene  '}
constructor TStarMapScene.Create(const AName: string);
begin
  inherited Create(AName);

  FMap := TStarMap.Create;
  FMap.LoadFromFile('..\data\map\starmap.map');
  //FMap.FillFirst;
end;

destructor TStarMapScene.Destroy;
begin
  FMap.Free;

  inherited;
end;

procedure TStarMapScene.OnInitialize(APameter: TObject);
begin
  FMap.BackToMap;
end;

procedure TStarMapScene.OnDraw(const ALayer: Integer);
begin
  TheEngine.Camera := nil;
  TheRender.Rectangle(0, 0,
    TheEngine.CurrentResolution.X, TheEngine.CurrentResolution.Y, $FF000000);

  FMap.OnDraw(0);
end;

procedure TStarMapScene.OnUpdate(const ADelta: Double);
begin
  FMap.OnUpdate(ADelta);
end;

procedure TStarMapScene.OnDestroy;
begin
  FMap.SaveToFile('..\data\map\starmap.map');
end;

function TStarMapScene.OnMouseMove(const AMousePosition: TVectorF): Boolean;
begin
  FMap.OnMouseMove(AMousePosition);
end;

function TStarMapScene.OnMouseButtonUp(AButton: TMouseButton;
  const AMousePosition: TVectorF): Boolean;
begin
  FMap.OnMouseButtonUp(AButton, AMousePosition);
end;

function TStarMapScene.OnKeyUp(AKey: TKeyButton): Boolean;
begin
  if AKey = KB_ESC then
  begin
    TheApplication.Stop;
    Exit;
  end;

  FMap.OnKeyUp(AKey);
end;
{$ENDREGION}

end.
