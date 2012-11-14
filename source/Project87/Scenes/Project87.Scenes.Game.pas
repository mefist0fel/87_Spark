unit Project87.Scenes.Game;

interface

uses
  QCore.Input,
  QEngine.Camera,
  QEngine.Texture,
  QEngine.Font,
  QGame.Scene,
  Strope.Math,
  Project87.Types.GameObject,
  Project87.Types.Starmap,
  Project87.Resources,
  Project87.Hero;

type
  TGameScene = class sealed (TScene)
    strict private
      FMainCamera: IQuadCamera;
      FGUICamera: IQuadCamera;

      FObjectManager: TObjectManager;
      FResource: TResources;
      FStartAnimation: Single;
      FShowMap: Single;
      FSystemResult: TStarSystemResult;
      FHero: THero;
      FFont: TQuadFont;
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
  QGame.Resources,
  Project87.Asteroid,
  Project87.Fluid,
  Project87.BaseUnit,
  Project87.BaseEnemy,
  Project87.BigEnemy,
  Project87.SmallEnemy,
  Project87.Types.SystemGenerator,
  QApplication.Application;

{$REGION '  TGameScene  '}
constructor TGameScene.Create(const AName: string);
begin
  inherited Create(AName);

  FObjectManager := TObjectManager.GetInstance;
  FResource := TResources.Create;
  FMainCamera := TheEngine.CreateCamera;
  FGUICamera := TheEngine.CreateCamera;

  FFont := (TheResourceManager.GetResource('Font', 'Quad_24') as TFontExResource).Font;
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
  AEnemies: array [0..LIFEFRACTION_COUNT - 1] of Single;
  AResources: array [0..FLUID_TYPE_COUNT - 1] of Single;
begin
  TheEngine.Camera := FMainCamera;
  FStartAnimation := 1;
  FShowMap := 1;

  for I := 0 to LIFEFRACTION_COUNT - 1 do
    AEnemies[I] := 0.5;
  for I := 0 to FLUID_TYPE_COUNT - 1 do
    AResources[I] := 0.5;
  FSystemResult := TStarSystemResult.Create(AEnemies, AResources);

  TObjectManager.GetInstance.ClearObjects();

  FHero := THero.CreateUnit(ZeroVectorF, Random(360), usHero);
  TSystemGenerator.GenerateSystem;

{  for I := 0 to 100 do
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
    TSmallEnemy.CreateUnit(Vec2F(Random(5000) - 2500, Random(5000) - 2500), Random(360), UnitSide);  }
//  for I := 0 to 400 do
//    TFluid.CreateFluid(Vec2F(Random(5000) - 2500, Random(5000) - 2500), TFluidType(Random(4)));
end;

procedure TGameScene.OnUpdate(const ADelta: Double);
begin
  if (FStartAnimation > 0) then
  begin
    FStartAnimation := FStartAnimation - ADelta * 2;
    FMainCamera.Scale := Vec2F(
      1 - FStartAnimation * FStartAnimation * 0.8,
      1 - FStartAnimation * FStartAnimation * 0.8);
    if (FStartAnimation <= 0) then
    begin
      FStartAnimation := 0;
      FMainCamera.Scale := Vec2F(1, 1);
    end;
  end;
  //Map
  if (TheControlState.Keyboard.IsKeyPressed[KB_TAB]) then
  begin
    if (FShowMap > 0.1) then
    begin
      FShowMap := FShowMap * 0.85;
      if FShowMap < 0.1 then
        FShowMap := 0.1;
      FMainCamera.Scale := Vec2F(FShowMap, FShowMap);
    end;
  end else
  if (FShowMap < 1) then
  begin
    FShowMap := FShowMap * 1.1;
    if FShowMap > 1 then
      FShowMap := 1;
    FMainCamera.Scale := Vec2F(FShowMap, FShowMap);
  end;

  FObjectManager.OnUpdate(ADelta);
end;

procedure TGameScene.OnDraw(const ALayer: Integer);
var
  I: Integer;
begin
  TheRender.Clear($FF000000);

  TheEngine.Camera := FMainCamera;
  TheRender.SetBlendMode(qbmSrcAlpha);

  FObjectManager.OnDraw;

  TheEngine.Camera := FGUICamera;
  FFont.TextOut(FloatToStr(FHero.Life), FGUICamera.GetWorldPos(Vec2F(10, 10)));
  FFont.TextOut(IntToStr(FHero.Fluid[0]), FGUICamera.GetWorldPos(Vec2F(10, 38)),
    1, $FFFFFF00);
  FFont.TextOut(IntToStr(FHero.Fluid[3]), FGUICamera.GetWorldPos(Vec2F(10, 63)),
    1, $FF0000FF);
  FFont.TextOut(IntToStr(FHero.Fluid[2]), FGUICamera.GetWorldPos(Vec2F(10, 88)),
    1, $FFFF0000);
  FFont.TextOut(IntToStr(FHero.Fluid[1]), FGUICamera.GetWorldPos(Vec2F(10, 113)),
    1, $FF00FF00);

  //Передавай камеру как-нибудь по другому в апдейт.
  TheEngine.Camera := FMainCamera;
end;

function TGameScene.OnKeyUp(AKey: Word): Boolean;
begin
  Result := False;
  if (AKey = KB_BACKSPACE) or (AKey = KB_ESC) then
  begin
    TheSceneManager.MakeCurrent('StarMap');
    TheSceneManager.OnInitialize(FSystemResult);
    //Потому что внутри я его чистю!
    FSystemResult := nil;
  end;
end;
{$ENDREGION}

end.
