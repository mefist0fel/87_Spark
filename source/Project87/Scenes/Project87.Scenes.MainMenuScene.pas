unit Project87.Scenes.MainMenuScene;

interface

uses
  QCore.Input,
  QGame.Scene,
  Strope.Math;

type
  TMainMenuScene = class sealed (TScene)
    strict private
    public
      constructor Create(const AName: string);
      destructor Destroy; override;
  end;

implementation

{$REGION '  TMainMenuScene  '}
constructor TMainMenuScene.Create(const AName: string);
begin
  inherited Create(AName);
end;

destructor TMainMenuScene.Destroy;
begin
  inherited;
end;
{$ENDREGION}

end.
