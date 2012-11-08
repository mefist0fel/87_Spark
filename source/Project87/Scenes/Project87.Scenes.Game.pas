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
var i: Byte;
begin
  FTestCamera := TheEngine.CreateCamera;
  TheEngine.Camera := FTestCamera;
  FImage := TheEngine.CreateTexture;
  FImage.LoadFromFile('..\data\gfx\miku.png', 0, 128, 128);
  TheRender.SetBlendMode(qbmSrcAlpha);

  for i := 0 to 10 do
    THero.Create(TVector2F.Create( Random(500) - 250, Random(500) - 250));
end;

procedure TGameScene.OnUpdate(const ADelta: Double);
begin
  FObjectManager.OnUpdate(ADelta);
end;

procedure TGameScene.OnDraw(const ALayer: Integer);
begin
  TheRender.Clear($FF000000);
  FObjectManager.OnDraw;
  FImage.Draw(ZeroVectorF, 0, 0);
  FImage.Draw(TVector2f.Create(100, 100), 0, 0);
end;
{$ENDREGION}

end.
