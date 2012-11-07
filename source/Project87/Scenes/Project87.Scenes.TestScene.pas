unit Project87.Scenes.TestScene;

interface

uses
  QCore.Input,
  QEngine.Camera,
  QEngine.Texture,
  QGame.Scene,
  Strope.Math;

type
  TTestScene = class sealed (TScene)
    strict private
      FTestCamera: IQuadCamera;
      FImage: TQuadTexture;
      FDelta: Single;
      FFrame: Integer;
    public
      constructor Create(const AName: string);
      destructor Destroy; override;

      procedure OnInitialize(AParameter: TObject = nil); override;
      procedure OnDraw(const ALayer: Integer); override;
      procedure OnUpdate(const ADelta: Double); override;
      procedure OnDestroy; override;
  end;

implementation

uses
  Math,
  QuadEngine,
  QEngine.Core,
  QGame.Game,
  QGame.Resources,
  QApplication.Application;

{$REGION '  TTestScene  '}
constructor TTestScene.Create(const AName: string);
begin
  inherited Create(AName);
end;

destructor TTestScene.Destroy;
begin
  inherited;
end;

procedure TTestScene.OnInitialize(AParameter: TObject);
begin
  FTestCamera := TheEngine.CreateCamera;

  TheResourceManager.AddResource(
    TTextureExResource.CreateAndLoad(
      'Texture', 'Sample', '..\data\gfx\miku.png', 0, 128, 128));
  FImage := (TheResourceManager.GetResource('Texture', 'Sample') as TTextureExResource).Texture;

  FDelta := 0;
  FFrame := 0;
end;

procedure TTestScene.OnDraw(const ALayer: Integer);
begin
  TheRender.Clear($FF000000);
  TheRender.SetBlendMode(qbmSrcAlpha);
  TheEngine.Camera := FTestCamera;
  //FTestCamera.IsUseCorrection := False;
  FTestCamera.CenterPosition := TVectorF.Create(0, 0);
  FTestCamera.Scale := TVectorF.Create(1, 1);
  FImage.Draw(TVectorF.Create(0, 0), TVectorF.Create(100, 100), TVectorF.Create(0, 0),
    90, FFrame, $FFFFFFFF);
end;

procedure TTestScene.OnUpdate(const ADelta: Double);
begin
  FDelta := FDelta + ADelta;
  if (FDelta > 0.1) then
  begin
    FDelta := 0;
    Inc(FFrame);
    FFrame := FFrame mod FImage.FramesCount;
  end;
end;

procedure TTestScene.OnDestroy;
begin
  FImage := nil;
end;
{$ENDREGION}

end.
