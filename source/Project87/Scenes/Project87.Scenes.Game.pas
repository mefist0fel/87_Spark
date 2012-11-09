unit Project87.Scenes.Game;

interface

uses
  QCore.Input,
  QEngine.Camera,
  QEngine.Texture,
  QGame.Scene,
  Strope.Math,
  Project87.Types.GameObject,
  Project87.Hero,
  Project87.Asteroid,
  Project87.Resources;

type
  TGameScene = class sealed (TScene)
    strict private
      FTestCamera: IQuadCamera;
      FImage: TQuadTexture;
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
  QuadEngine,
  QEngine.Core,
  QApplication.Application;

{$REGION '  TGameScene  '}
constructor TGameScene.Create(const AName: string);
begin
  FObjectManager := TObjectManager.GetInstance;
  FResource := TResources.Create;
  inherited Create(AName);
end;

destructor TGameScene.Destroy;
begin
  inherited;
end;

procedure TGameScene.OnInitialize(AParameter: TObject);
var
  I: Byte;
begin
  FTestCamera := TheEngine.CreateCamera;
  TheEngine.Camera := FTestCamera;
  FTestCamera.Position := TVector2F.Create(300, 140);

  FImage := TheEngine.CreateTexture;
  FImage.LoadFromFile('..\data\gfx\miku.png', 0, 128, 128);
  TheRender.SetBlendMode(qbmSrcAlpha);

  THero.CreateHero(ZeroVectorF);

  for i := 0 to 100 do
    TAsteroid.Create(TVector2F.Create( Random(5000) - 2500, Random(5000) - 2500), Random(360), 20 + Random(100));
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
  FObjectManager.OnDraw;
end;
{$ENDREGION}

end.
