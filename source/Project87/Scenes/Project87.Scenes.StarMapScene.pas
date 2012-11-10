unit Project87.Scenes.StarMapScene;

interface

uses
  QCore.Input,
  QGame.Scene,
  Project87.Types.StarMap;

type
  TStarMapScene = class sealed (TScene)
    strict private
      FMap: TStarMap;
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
  QuadEngine,
  QEngine.Core;

{$REGION '  TStarMapScene  '}
constructor TStarMapScene.Create(const AName: string);
begin
  inherited Create(AName);

  FMap := TStarMap.Create;
  FMap.LoadFromFile('..\data\map\starmap.map');
  //FMap.FillFirst;
end;

destructor TStarMapScene.Destroy;
begin
  FMap.Free;

  inherited;
end;

procedure TStarMapScene.OnInitialize(APameter: TObject);
begin
  //
end;

procedure TStarMapScene.OnDraw(const ALayer: Integer);
begin
  FMap.OnDraw(0);
end;

procedure TStarMapScene.OnUpdate(const ADelta: Double);
begin
  FMap.OnUpdate(0);
end;

procedure TStarMapScene.OnDestroy;
begin
  FMap.SaveToFile('..\data\map\starmap.map');
end;
{$ENDREGION}

end.
