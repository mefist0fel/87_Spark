unit Project87.Scenes.Game;

interface

uses
  QCore.Input,
  QEngine.Camera,
  QEngine.Texture,
  QGame.Scene,
  Strope.Math,
  Project87.Types.GameObject,
  Project87.Types.Starmap,
  Project87.Resources;

type
  TGameScene = class sealed (TScene)
    strict private
      FMainCamera: IQuadCamera;
      FObjectManager: TObjectManager;
      FResource: TResources;
      FStartAnimation: Single;
      FSystemResult: TStarSystemResult;
    public
      constructor Create(const AName: string);
      destructor Destroy; override;

      procedure OnInitialize(AParameter: TObject = nil); override;
      procedure OnUpdate(const ADelta: Double); override;
      procedure OnDraw(const ALayer: Integer); override;

      function OnKeyUp(AKey: TKeyButton): Boolean; override;
  end;

implementation

uses
  SysUtils,
  QuadEngine,
  QEngine.Core,
  QGame.Game,
  Project87.Hero,
  Project87.Asteroid,
  Project87.Fluid,
  Project87.BaseUnit,
  Project87.BaseEnemy,
  Project87.BigEnemy,
  Project87.SmallEnemy,
  QApplication.Application;

{$REGION '  TGameScene  '}
constructor TGameScene.Create(const AName: string);
begin
  inherited Create(AName);

  FSystemResult := TStarSystemResult.Create(0.5, 0.5);
  FObjectManager := TObjectManager.GetInstance;
  FResource := TResources.Create;
  FMainCamera := TheEngine.CreateCamera;
end;

destructor TGameScene.Destroy;
begin
  FreeAndNil(FObjectManager);
  FreeAndNil(FResource);

  inherited;
end;

procedure TGameScene.OnInitialize(AParameter: TObject);
var
  I: Word;
  UnitSide: TUnitSide ;
begin
  TheEngine.Camera := FMainCamera;
  FStartAnimation := 1;

  TObjectManager.GetInstance.ClearObjects();

  THero.CreateUnit(ZeroVectorF, Random(360), usHero);

  for I := 0 to 100 do
    TAsteroid.CreateAsteroid(
      Vec2F(Random(5000) - 2500, Random(5000) - 2500),
      Random(360), 20 + Random(100),
      TFluidType(Random(4)));
  UnitSide := TUnitSide(Random(3) + 2);
  for I := 0 to 40 do
    TBaseEnemy.CreateUnit(Vec2F(Random(5000) - 2500, Random(5000) - 2500), Random(360), UnitSide);
  for I := 0 to 10 do
    TBigEnemy.CreateUnit(Vec2F(Random(5000) - 2500, Random(5000) - 2500), Random(360), UnitSide);
  for I := 0 to 20 do
    TSmallEnemy.CreateUnit(Vec2F(Random(5000) - 2500, Random(5000) - 2500), Random(360), UnitSide);
//  for I := 0 to 400 do
//    TFluid.CreateFluid(Vec2F(Random(5000) - 2500, Random(5000) - 2500), TFluidType(Random(4)));
end;

procedure TGameScene.OnUpdate(const ADelta: Double);
begin
  if (FStartAnimation > 0) then
  begin
    FStartAnimation := FStartAnimation - ADelta * 2;
    TheEngine.Camera.Scale := Vec2F(1 - FStartAnimation * FStartAnimation * 0.8, 1 - FStartAnimation * FStartAnimation * 0.8);
    if (FStartAnimation <= 0) then
    begin
      FStartAnimation := 0;
      TheEngine.Camera.Scale := Vec2F(1, 1);
    end;
  end;

  FObjectManager.OnUpdate(ADelta);
end;

procedure TGameScene.OnDraw(const ALayer: Integer);
begin
  TheRender.Clear($FF000000);

  TheEngine.Camera := FMainCamera;
  TheRender.SetBlendMode(qbmSrcAlpha);
  FObjectManager.OnDraw;
end;

function TGameScene.OnKeyUp(AKey: Word): Boolean;
begin
  Result := False;
  if (AKey = KB_BACKSPACE) or (AKey = KB_ESC) then
  begin
    TheSceneManager.MakeCurrent('StarMap');
    TheSceneManager.OnInitialize(FSystemResult);
  end;
end;
{$ENDREGION}

end.
