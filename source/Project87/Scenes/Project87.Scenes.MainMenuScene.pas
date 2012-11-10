unit Project87.Scenes.MainMenuScene;

interface

uses
  QCore.Input,
  QGame.Scene,
  Strope.Math,
  QEngine.Camera,
  QEngine.Font;

type
  TMainMenuScene = class sealed (TScene)
    strict private
      FCamera: IQuadCamera;
      FFont: TQuadFont;
    public
      constructor Create(const AName: string);
      destructor Destroy; override;

      procedure OnInitialize(APameter: TObject = nil); override;
      procedure OnDraw(const ALayer: Integer); override;
      procedure OnUpdate(const ADelta: Double); override;
      procedure OnDestroy; override;
  end;

implementation

uses
  SysUtils,
  QuadEngine,
  QEngine.Core,
  QGame.Game,
  QGame.Resources;

{$REGION '  TMainMenuScene  '}
constructor TMainMenuScene.Create(const AName: string);
begin
  inherited Create(AName);
end;

destructor TMainMenuScene.Destroy;
begin
  inherited;
end;

procedure TMainMenuScene.OnInitialize(APameter: TObject);
begin
  FCamera := TheEngine.CreateCamera;
  FFont := (TheResourceManager.GetResource('Font', 'Droid_28') as TFontExResource).Font;
end;

procedure TMainMenuScene.OnDraw(const ALayer: Integer);
const
  GameName = 'Spark';
var
  APoint, AShift, ASize: TVectorF;
begin
  TheEngine.Camera := nil;
  TheRender.Rectangle(0, 0, FCamera.Resolution.X, FCamera.Resolution.Y, $FF000000);

  TheEngine.Camera := FCamera;

  APoint.Y := FCamera.GetWorldSize(FCamera.Resolution * 0.25).Y;
  APoint.X := APoint.Y;
  APoint := APoint + FCamera.GetWorldPos(ZeroVectorF);
  AShift := FCamera.GetWorldSize(Vec2F(FCamera.Resolution.X, FCamera.Resolution.X));
  ASize := FCamera.GetWorldSize(Vec2F(10, 10));

  TheRender.RectangleEx(APoint.X, APoint.Y, APoint.X + AShift.X, APoint.Y + ASize.Y,
    $FFFFFFFF, $80B0B0B0, $FFFFFFFF, $80B0B0B0);
  TheRender.RectangleEx(APoint.X - AShift.X, APoint.Y, APoint.X, APoint.Y + ASize.Y,
    $80B0B0B0, $FFFFFFFF, $80B0B0B0, $FFFFFFFF);
  TheRender.RectangleEx(APoint.X, APoint.Y, APoint.X + ASize.X, APoint.Y + AShift.Y,
    $FFFFFFFF, $FFFFFFFF, $80B0B0B0, $80B0B0B0);
  TheRender.RectangleEx(APoint.X, APoint.Y - AShift.Y, APoint.X + ASize.X, APoint.Y,
    $80B0B0B0, $80B0B0B0, $FFFFFFFF, $FFFFFFFF);


  TheRender.SetBlendMode(qbmSrcAlpha);
  AShift := Vec2F(-FFont.TextWidth('    ', 4), FFont.TextHeight(GameName, 4));
  FFont.TextOut(GameName, APoint - AShift, 4, $FFFFFFFF);
end;

procedure TMainMenuScene.OnUpdate(const ADelta: Double);
begin

end;

procedure TMainMenuScene.OnDestroy;
begin
  FreeAndNil(FFont);
end;
{$ENDREGION}

end.
