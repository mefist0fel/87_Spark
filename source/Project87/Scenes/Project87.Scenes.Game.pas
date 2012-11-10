unit Project87.Scenes.Game;

interface

uses
  QCore.Input,
  QEngine.Camera,
  QEngine.Texture,
  QGame.Scene,
  Strope.Math,
  Project87.Types.GameObject,
  Project87.Resources;

type
  TGameScene = class sealed (TScene)
    strict private
      FMainCamera: IQuadCamera;
      FObjectManager: TObjectManager;
      FResource: TResources;
      FStartAnimation: Single;
    public
      constructor Create(const AName: string);
      destructor Destroy; override;

      procedure OnInitialize(AParameter: TObject = nil); override;
      procedure OnUpdate(const ADelta: Double); override;
      procedure OnDraw(const ALayer: Integer); override;
  end;

implementation

uses
  SysUtils,
  QuadEngine,
  QEngine.Core,
  Project87.Hero,
  Project87.Asteroid,
  Project87.Fluid,
  Project87.BaseEnemy,
  Project87.BaseUnit,
  QApplication.Application;

{$REGION '  TGameScene  '}
constructor TGameScene.Create(const AName: string);
begin
  inherited Create(AName);

  FObjectManager := TObjectManager.GetInstance;
  FResource := TResources.Create;
end;

destructor TGameScene.Destroy;
begin
  FreeAndNil(FObjectManager);
  FreeAndNil(FResource);

  inherited;
end;

procedure TGameScene.OnInitialize(AParameter: TObject);
var
  I: Word;
begin
  FMainCamera := TheEngine.CreateCamera;
  FMainCamera.Position := Vec2F(300, 140);
  TheEngine.Camera := FMainCamera;

  FStartAnimation := 1;

  THero.CreateHero(ZeroVectorF);

  for I := 0 to 100 do
    TAsteroid.CreateAsteroid(
      Vec2F(Random(5000) - 2500, Random(5000) - 2500),
      Random(360), 20 + Random(100));
  for I := 0 to 40 do
    TBaseEnemy.CreateUnit(Vec2F(Random(5000) - 2500, Random(5000) - 2500), Random(360), usRed);

  for I := 0 to 100 do
    TFluid.CreateFluid(Vec2F(Random(5000) - 2500, Random(5000) - 2500));
end;

procedure TGameScene.OnUpdate(const ADelta: Double);
begin
  if (FStartAnimation > 0) then
  begin
    FStartAnimation := FStartAnimation - ADelta;
    TheEngine.Camera.Scale := Vec2F(1 - FStartAnimation * FStartAnimation * 0.8, 1 - FStartAnimation * FStartAnimation * 0.8);
    if (FStartAnimation <= 0) then
    begin
      FStartAnimation := 0;
      TheEngine.Camera.Scale := Vec2F(1, 1);
    end;
  end;


  if TheControlState.Keyboard.IsKeyPressed[KB_ESC] then
  begin
    TheApplication.Stop;
    Exit;
  end;
  FObjectManager.OnUpdate(ADelta);
end;

procedure TGameScene.OnDraw(const ALayer: Integer);
begin
  TheRender.Clear($FF000000);

  TheEngine.Camera := FMainCamera;
  TheRender.SetBlendMode(qbmSrcAlpha);
  FObjectManager.OnDraw;
end;
{$ENDREGION}

end.
