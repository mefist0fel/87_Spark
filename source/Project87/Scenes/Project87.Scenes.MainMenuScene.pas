unit Project87.Scenes.MainMenuScene;

interface

uses
  QCore.Input,
  QGame.Scene,
  Strope.Math,
  QEngine.Camera,
  QEngine.Texture,
  QEngine.Font;

type
  TMainMenuScene = class sealed (TScene)
    strict private
      FCamera: IQuadCamera;
      FFont: TQuadFont;
      FStar: TQuadTexture;
      FStarTime: Single;
    public
      constructor Create(const AName: string);
      destructor Destroy; override;

      procedure OnInitialize(APameter: TObject = nil); override;
      procedure OnDraw(const ALayer: Integer); override;
      procedure OnUpdate(const ADelta: Double); override;
  end;

implementation

uses
  Math,
  SysUtils,
  QuadEngine,
  QEngine.Core,
  QGame.Game,
  QGame.Resources,
  direct3d9;

{$REGION '  TMainMenuScene  '}
const
  STAR_PULSATION_PERIOD = 2;
  STAR_PULSATION_AMPLITUDE = 0.3;

constructor TMainMenuScene.Create(const AName: string);
begin
  inherited Create(AName);
  FCamera := TheEngine.CreateCamera;
  FFont := (TheResourceManager.GetResource('Font', 'Quad_72') as TFontExResource).Font;
  FStar := (TheResourceManager.GetResource('Image', 'BigMenuStar') as TTextureExResource).Texture;
end;

destructor TMainMenuScene.Destroy;
begin
  inherited;
end;

procedure TMainMenuScene.OnInitialize(APameter: TObject);
begin
  FStarTime := 0;
end;

procedure TMainMenuScene.OnDraw(const ALayer: Integer);
const
  GameName = 'Spark';
var
  APoint, AShift, ASize: TVectorF;
  AAlpha: Single;
begin
  TheEngine.Camera := nil;
  TheRender.Rectangle(0, 0, FCamera.Resolution.X, FCamera.Resolution.Y, $FF000000);

  TheEngine.Camera := FCamera;
  TheRender.SetBlendMode(qbmSrcAlpha);

  APoint.Y := FCamera.GetWorldSize(FCamera.Resolution * 0.25).Y;
  APoint.X := APoint.Y;
  APoint := APoint + FCamera.GetWorldPos(ZeroVectorF);
  AShift := FCamera.GetWorldSize(Vec2F(FCamera.Resolution.X, FCamera.Resolution.X)) * 0.4;
  ASize := FCamera.GetWorldSize(Vec2F(2, 2));

  TheRender.RectangleEx(APoint.X, APoint.Y, APoint.X + AShift.X, APoint.Y + ASize.Y,
    $80FFFFFF, $00B0B0B0, $80FFFFFF, $00B0B0B0);
  TheRender.RectangleEx(APoint.X - AShift.X, APoint.Y, APoint.X, APoint.Y + ASize.Y,
    $00B0B0B0, $FFFFFFFF, $00B0B0B0, $80FFFFFF);
  TheRender.RectangleEx(APoint.X, APoint.Y, APoint.X + ASize.X, APoint.Y + AShift.Y,
    $80FFFFFF, $80FFFFFF, $00B0B0B0, $00B0B0B0);
  TheRender.RectangleEx(APoint.X, APoint.Y - AShift.Y, APoint.X + ASize.X, APoint.Y,
    $00B0B0B0, $00B0B0B0, $80FFFFFF, $80FFFFFF);

  AAlpha := 2 * Pi * FStarTime / STAR_PULSATION_PERIOD;
  AAlpha := 0.5 * (1 + Sin(AAlpha));
  AAlpha := STAR_PULSATION_AMPLITUDE * AAlpha;
  FStar.Draw(APoint + ASize * 0.5 - Vec2F(1, 3.5), FCamera.GetWorldSize(Vec2F(160, 160)),
    -38.5, $FFFFFFFF);
  FStar.Draw(APoint + ASize * 0.5 - Vec2F(1, 3.5), FCamera.GetWorldSize(Vec2F(300, 300)),
    -38.5, D3DCOLOR_COLORVALUE(1, 1, 1, AAlpha));

  AShift := Vec2F(-FCamera.GetWorldSize(FCamera.Resolution).X * 0.04, 74 * 1.3);
  FFont.TextOut(GameName, APoint - AShift, 1.3, $FFFFFFFF);
end;

procedure TMainMenuScene.OnUpdate(const ADelta: Double);
begin
  FStarTime := FStarTime + ADelta;
  if FStarTime > STAR_PULSATION_PERIOD then
    FStarTime := FStarTime - STAR_PULSATION_PERIOD;
end;
{$ENDREGION}

end.
