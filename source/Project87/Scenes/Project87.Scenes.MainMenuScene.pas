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

      procedure OnInitialize(APameter: TObject = nil); override;
      procedure OnDraw(const ALayer: Integer); override;
      procedure OnUpdate(const ADelta: Double); override;
      procedure OnDestroy; override;
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

procedure TMainMenuScene.OnInitialize(APameter: TObject);
begin

end;

procedure TMainMenuScene.OnDraw(const ALayer: Integer);
begin

end;

procedure TMainMenuScene.OnUpdate(const ADelta: Double);
begin

end;

procedure TMainMenuScene.OnDestroy;
begin

end;
{$ENDREGION}

end.
