unit Project87.Scenes.StarMapScene;

interface

uses
  QCore.Input,
  QGame.Scene,
  Strope.Math,
  Project87.Types.StarMap,
  Project87.Types.HeroInterface;

type
  TStarMapSceneParameters = class sealed
    strict private
      FIsNewGame: Boolean;
    public
      constructor Create(AIsNewGame: Boolean);

      property IsNewGame: Boolean read FIsNewGame;
  end;

  TStarMapScene = class sealed (TScene)
    strict private
      FMap: TStarMap;
      FInterface: THeroInterface;
    public
      constructor Create(const AName: string);
      destructor Destroy; override;

      procedure OnInitialize(AParameter: TObject = nil); override;
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
  QApplication.Application,
  Project87.Hero;

{$REGION '  TStarMapSceneParameters  '}
constructor TStarMapSceneParameters.Create(AIsNewGame: Boolean);
begin
  FIsNewGame := AIsNewGame;
end;
{$ENDREGION}

{$REGION '  TStarMapScene  '}
const
  STARMAP_FILE = '..\data\map\starmap.map';

constructor TStarMapScene.Create(const AName: string);
begin
  inherited Create(AName);

  FInterface := THeroInterface.Create(THero.GetInstance);
  FMap := TStarMap.Create;
end;

destructor TStarMapScene.Destroy;
begin
  FMap.Free;

  inherited;
end;

procedure TStarMapScene.OnInitialize(AParameter: TObject);
begin
  if not Assigned(AParameter) then
  begin
    FMap.Clear;
    FMap.LoadFromFile(STARMAP_FILE);
    FMap.BackToMap;
    Exit;
  end;

  if AParameter is TStarMapSceneParameters then
  begin
    FMap.Clear;
    if (AParameter as TStarMapSceneParameters).IsNewGame then
    begin
      THero.GetInstance.NewPlayer;
      FMap.OnInitialize
    end
    else
    begin
      THero.GetInstance.LoadFromFile('..\data\map\player.user');
      FMap.LoadFromFile(STARMAP_FILE);
    end;
    FMap.BackToMap;
    Exit;
  end;

  if AParameter is TStarSystemResult then
    FMap.BackToMap(AParameter as TStarSystemResult)
  else
    FMap.BackToMap;
end;

procedure TStarMapScene.OnDraw(const ALayer: Integer);
begin
  TheEngine.Camera := nil;
  TheRender.Rectangle(0, 0,
    TheEngine.CurrentResolution.X, TheEngine.CurrentResolution.Y, $FF000000);

  FMap.OnDraw(0);
  FInterface.OnDraw;
end;

procedure TStarMapScene.OnUpdate(const ADelta: Double);
begin
  FMap.OnUpdate(ADelta);
  THero.GetInstance.UpdateLife(ADelta);
end;

procedure TStarMapScene.OnDestroy;
begin
  FMap.SaveToFile(STARMAP_FILE);
  THero.GetInstance.SaveToFile('..\data\map\player.user');
end;

function TStarMapScene.OnMouseMove(const AMousePosition: TVectorF): Boolean;
begin
  Result := True;
  FMap.OnMouseMove(AMousePosition);
end;

function TStarMapScene.OnMouseButtonUp(AButton: TMouseButton;
  const AMousePosition: TVectorF): Boolean;
begin
  Result := True;
  FMap.OnMouseButtonUp(AButton, AMousePosition);
end;

function TStarMapScene.OnKeyUp(AKey: TKeyButton): Boolean;
begin
  Result := True;

  if AKey = KB_ESC then
  begin
    TheApplication.Stop;
    Exit;
  end;

  FMap.OnKeyUp(AKey);
end;
{$ENDREGION}

end.
