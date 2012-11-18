unit Project87.Game;

interface

uses
  QGame.Game,
  QEngine.Core,
  QEngine.Camera;

type
  TProject87Game = class sealed (TQGame)
    strict private
      procedure PrepareUnavailableBuffer;
    strict protected
      function GetGameVersion(): string; override;
    public
      constructor Create;

      procedure OnInitialize(AParameter: TObject = nil); override;
  end;

implementation

uses
  QuadEngine,
  QEngine.Texture,
  Project87.Scenes.IntroScene,
  Project87.Scenes.MainMenuScene,
  Project87.Scenes.StarMapScene,
  Project87.Scenes.Game,
  Project87.Scenes.TestScene,
  QGame.Resources,
  Strope.Math;

{$REGION '  TProject87Game  '}
constructor TProject87Game.Create;
begin
  inherited;

  FGameName := 'Spark';
  FGameAutors := 'Mefistofel and Bloov';
  FGameVersion := 0;
  FGameVersionMajor := 1;
  FGameVersionMinor := 10;
end;

procedure TProject87Game.PrepareUnavailableBuffer;
var
  ATexture: TQuadTexture;
  ABuffer: IQuadTexture;
  I, J: Integer;
begin
  ABuffer := nil;
  TheRender.CreateRenderTexture(
    Trunc(TheEngine.CurrentResolution.X), Trunc(TheEngine.CurrentResolution.Y),
    ABuffer, 0);

  ATexture :=
    (TheResourceManager.GetResource('Image', 'Unavailable') as TTextureExResource).Texture;

  TheRender.BeginRender;
    TheEngine.Camera := nil;
    TheRender.RenderToTexture(True, ABuffer);
    for I := 0 to Trunc(TheEngine.CurrentResolution.X) div Trunc(ATexture.SpriteSize.X) + 1 do
      for J := 0 to Trunc(TheEngine.CurrentResolution.Y) div Trunc(ATexture.SpriteSize.Y) + 1 do
        ATexture.DrawByLeftTop(
          Vec2F(ATexture.SpriteSize.X * I, ATexture.SpriteSize.Y * J),
          0, $FFFFFFFF);
    TheRender.RenderToTexture(False, ABuffer);
  TheRender.EndRender;

  TheResourceManager.AddResource(TTextureResource.Create('Image', 'UnavailableBuffer', ABuffer));
end;

function TProject87Game.GetGameVersion;
begin
  Result := 'Prototype Alpha';
end;

procedure TProject87Game.OnInitialize(AParameter: TObject = nil);
const
  AFntDir = '..\data\fnt\';
  AGfxDir = '..\data\gfx\';
var
  AFontEx: TFontExResource;
  ATextureEx: TTextureExResource;
  ASceneParameter: TStarMapSceneParameters;
begin
  //Создавать сцены и загружать основные ресурсы тут
  AFontEx := TFontExResource.CreateAndLoad('Font', 'Droid_28',
    AFntDir + 'droid_sans_bold_28.png', AFntDir + 'droid_sans_bold_28.qef');
  ResourceManager.AddResource(AFontEx);

  AFontEx := TFontExResource.CreateAndLoad('Font', 'Quad_14',
    AFntDir + 'quad_14.png', AFntDir + 'quad_14.qef');
  ResourceManager.AddResource(AFontEx);

  AFontEx := TFontExResource.CreateAndLoad('Font', 'Quad_24',
    AFntDir + 'quad_24.png', AFntDir + 'quad_24.qef');
  ResourceManager.AddResource(AFontEx);

  AFontEx := TFontExResource.CreateAndLoad('Font', 'Quad_72',
    AFntDir + 'quad_72.png', AFntDir + 'quad_72.qef');
  ResourceManager.AddResource(AFontEx);

  ATextureEx := TTextureExResource.CreateAndLoad('Image', 'BigMenuStar',
    AGfxDir + 'menu_elements\big_star.png', 0);
  ResourceManager.AddResource(ATextureEx);

  ATextureEx := TTextureExResource.CreateAndLoad('Image', 'SimpleStarMarker',
    AGfxDir + 'starmap_elements\marker_focused.png', 0);
  ResourceManager.AddResource(ATextureEx);

  ATextureEx := TTextureExResource.CreateAndLoad('Image', 'Unavailable',
    AGfxDir + 'starmap_elements\unavailable.png', 0);
  ResourceManager.AddResource(ATextureEx);

  ATextureEx := TTextureExResource.CreateAndLoad('Image', 'SystemInfoCompact',
    AGfxDir + 'starmap_elements\system_compact.png', 0);
  ResourceManager.AddResource(ATextureEx);

  ATextureEx := TTextureExResource.CreateAndLoad('Image', 'SystemInfoPlanet',
    AGfxDir + 'starmap_elements\system_planet.png', 0);
  ResourceManager.AddResource(ATextureEx);

  ATextureEx := TTextureExResource.CreateAndLoad('Image', 'SystemInfoDischarged',
    AGfxDir + 'starmap_elements\system_discharged.png', 0);
  ResourceManager.AddResource(ATextureEx);

  ATextureEx := TTextureExResource.CreateAndLoad('Image', 'SystemEdge',
    AGfxDir + 'starmap_elements\edge.png', 0);
  ResourceManager.AddResource(ATextureEx);

  ATextureEx := TTextureExResource.CreateAndLoad('Image', 'SystemEnemy',
    AGfxDir + 'starmap_elements\enemy.png', 0);
  ResourceManager.AddResource(ATextureEx);

  PrepareUnavailableBuffer;

  SceneManager.AddScene(TIntroScene.Create('Intro'));
  SceneManager.AddScene(TMainMenuScene.Create('MainMenu'));
  SceneManager.AddScene(TStarMapScene.Create('StarMap'));
  SceneManager.AddScene(TGameScene.Create('Spark'));
  SceneManager.MakeCurrent('Intro');
  //SceneManager.MakeCurrent('StarMap');
  //SceneManager.MakeCurrent('Spark');

  ASceneParameter := TStarMapSceneParameters.Create(False);
  SceneManager.OnInitialize(ASceneParameter);
end;
{$ENDREGION}

end.
