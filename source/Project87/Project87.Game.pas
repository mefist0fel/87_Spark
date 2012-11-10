unit Project87.Game;

interface

uses
  QGame.Game,
  QEngine.Core,
  QEngine.Camera;

type
  TProject87Game = class sealed (TQGame)
    strict private
    strict protected
      function GetGameVersion(): string; override;
    public
      constructor Create;

      procedure OnInitialize(AParameter: TObject = nil); override;
  end;

implementation

uses
  Project87.Scenes.IntroScene,
  Project87.Scenes.MainMenuScene,
  Project87.Scenes.Game,
  Project87.Scenes.TestScene,
  QGame.Resources;

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

  SceneManager.AddScene(TIntroScene.Create('Intro'));
  SceneManager.AddScene(TMainMenuScene.Create('MainMenu'));
  SceneManager.AddScene(TGameScene.Create('Spark'));
  //SceneManager.MakeCurrent('Intro');
  SceneManager.MakeCurrent('Spark');
  SceneManager.OnInitialize;
end;
{$ENDREGION}

end.
