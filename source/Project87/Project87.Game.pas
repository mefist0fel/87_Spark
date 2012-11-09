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
  Project87.Scenes.Game,
  Project87.Scenes.TestScene;

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
begin
  //Создавать сцены и загружать основные ресурсы тут
  SceneManager.AddScene(TGameScene.Create('Spark'));
  SceneManager.AddScene(TIntroScene.Create('Intro'));
  SceneManager.MakeCurrent('Intro');
  SceneManager.OnInitialize;
end;
{$ENDREGION}

end.
