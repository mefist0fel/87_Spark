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
      FTestCamera: IQuadCamera;
      FObjectManager: TObjectManager;
      FResource: TResources;
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
  FTestCamera := TheEngine.CreateCamera;
  FTestCamera.Position := Vec2F(300, 140);
  TheEngine.Camera := FTestCamera;

  THero.CreateHero(ZeroVectorF);

  for I := 0 to 100 do
    TAsteroid.CreateAsteroid(
      Vec2F(Random(5000) - 2500, Random(5000) - 2500),
      Random(360), 20 + Random(100));

  for I := 0 to 100 do
    TFluid.CreateFluid(Vec2F(Random(5000) - 2500, Random(5000) - 2500));
end;

procedure TGameScene.OnUpdate(const ADelta: Double);
begin
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

  TheEngine.Camera := FTestCamera;
  TheRender.SetBlendMode(qbmSrcAlpha);
  FObjectManager.OnDraw;
end;
{$ENDREGION}

end.
