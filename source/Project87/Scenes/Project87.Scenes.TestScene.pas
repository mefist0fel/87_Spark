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
      FPosition: TVectorF;
      FTestCamera: IQuadCamera;
      FImage: TQuadTexture;
      FScale: TVectorF;
      FDelta: Single;
      FTime: Single;
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
  TheEngine.Camera := FTestCamera;

  TheResourceManager.AddResource(
    TTextureExResource.CreateAndLoad(
      'Texture', 'Sample', '..\data\gfx\miku.png', 0, 128, 128));
  FImage := (TheResourceManager.GetResource('Texture', 'Sample') as TTextureExResource).Texture;

  FDelta := 0;
  FTime := 0;
  FFrame := 0;
  FScale := TVectorF.Create(2, 2);
end;

procedure TTestScene.OnDraw(const ALayer: Integer);
begin
  TheRender.Clear($FF000000);
  TheRender.SetBlendMode(qbmSrcAlpha);

  FTestCamera.Scale := FScale;
  FTestCamera.LeftTopPosition := FTestCamera.WorldSize[FPosition - FTestCamera.Resolution * 0.5];

  FImage.Draw(ZeroVectorF, 0, FFrame, $FFFFFFFF);
  FImage.Draw(TVectorF.Create(100, 100),
    FTestCamera.WorldSize[FImage.FrameSize], ZeroVectorF, 90, FFrame, $FFFFFFFF);
end;

procedure TTestScene.OnUpdate(const ADelta: Double);
begin
  FDelta := FDelta + ADelta;
  FTime := FTime + ADelta;
  if (FDelta > 0.1) then
  begin
    FDelta := 0;
    Inc(FFrame);
    FFrame := FFrame mod FImage.FramesCount;
  end;
  if FTime > 10 then
    FTime := 0;

  FPosition.Create(
    200 * Cos(FTime * 2 * Pi / 10),
    200 * Sin(FTime * 2 * Pi / 10));

  if TheMouseState.WheelState = mwsUp then
    FScale := FScale * 1.05;
  if TheMouseState.WheelState = mwsDown then
    FScale := FScale * 0.95;
end;

procedure TTestScene.OnDestroy;
begin
  FImage := nil;
end;
{$ENDREGION}

end.
