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
  FFont := (TheResourceManager.GetResource('Font', 'Quad_24') as TFontExResource).Font;
end;

procedure TMainMenuScene.OnDraw(const ALayer: Integer);
begin
  TheEngine.Camera := nil;
  TheRender.Rectangle(0, 0, FCamera.Resolution.X, FCamera.Resolution.Y, $FF000000);

  TheEngine.Camera := FCamera;
  TheRender.SetBlendMode(qbmSrcAlpha);
  FFont.TextOut('Some test text', FCamera.GetWorldPos(Vec2F(100, 100)), 1, $FFFFFFFF);
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
