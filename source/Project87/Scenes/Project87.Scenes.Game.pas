unit Project87.Scenes.Game;

interface

uses
  QCore.Input,
  QEngine.Camera,
  QEngine.Texture,
  QGame.Scene,
  Strope.Math,
  Project87.GameObject,
  Project87.Hero,
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
  QEngine.Core;

{$REGION '  TTestScene  '}
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
var i: Byte;
begin
  FTestCamera := TheEngine.CreateCamera;
  FImage := TheEngine.CreateTexture;
  FImage.LoadFromFile('..\data\gfx\miku.png', 0, 128, 128);

  for i := 0 to 10 do
    THero.Create(TVector2F.Create( Random(500), Random(500)));
end;

procedure TGameScene.OnUpdate(const ADelta: Double);
begin
  FObjectManager.OnUpdate(ADelta);
end;

procedure TGameScene.OnDraw(const ALayer: Integer);
begin
  FObjectManager.OnDraw;
  TheRender.Clear($FF000000);
  TheRender.SetBlendMode(qbmSrcAlpha);
  TheEngine.Camera := FTestCamera;
  FImage.Draw(TVectorF.Create(0, 0), TVectorF.Create(200, 200), 0.0, 1, $FFFFFFFF);
end;
{$ENDREGION}

end.
