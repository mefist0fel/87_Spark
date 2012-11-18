unit Project87.Scenes.Game;

interface

uses
  QuadEngine,
  QCore.Input,
  QEngine.Camera,
  QEngine.Texture,
  QGame.Scene,
  Strope.Math,
  Project87.Types.GameObject,
  Project87.Types.Starmap,
  Project87.Types.HeroInterface,
  Project87.Resources,
  Project87.Hero;

type
  TGameScene = class sealed (TScene)
    strict private
      FMainCamera: IQuadCamera;
      FInterface: THeroInterface;

      FUnavailableBuffer: IQuadTexture;
      FUnavailableShader: IQuadShader;
      FUnCenter: array [0..1] of Single;
      FUnRadius, FNeedUnRadius: Single;
      FUnRatio: array [0..1] of Single;

      FHero: THero;

      FObjectManager: TObjectManager;
      FResource: TGameResources;
      FStartAnimation: Single;
      FShowMap: Single;
      FSystemResult: TStarSystemResult;
      FHeroShip: THeroShip;

      procedure SetupShader;
      procedure UpdateStartAnimation(const ADelta: Double);
      procedure ShowLocalMap;
      procedure PrepareConstrainData;
      procedure DrawConstrain;
      procedure BackToMap;
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
  Math,
  SysUtils,
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
  QApplication.Application,
  Project87.Types.StarFon;

{$REGION '  TGameScene  '}
constructor TGameScene.Create(const AName: string);
begin
  inherited Create(AName);

  FObjectManager := TObjectManager.GetInstance;
  FResource := TGameResources.Create;
  FMainCamera := TheEngine.CreateCamera;

  FHero := THero.GetInstance;
  FInterface := THeroInterface.Create(FHero);

  FUnavailableBuffer :=
    (TheResourceManager.GetResource('Image', 'UnavailableBuffer') as TTextureResource).Texture;
  SetupShader;
end;

destructor TGameScene.Destroy;
begin
  FreeAndNil(FObjectManager);
  FreeAndNil(FResource);

  inherited;
end;

procedure TGameScene.SetupShader;
begin
  TheDevice.CreateShader(FUnavailableShader);
  FUnavailableShader.LoadPixelShader('..\data\shd\unavailable.bin');
  FUnavailableShader.BindVariableToPS(1, @FUnRadius, 1);
  FUnavailableShader.BindVariableToPS(2, @FUnRatio, 1);
  FUnavailableShader.BindVariableToPS(3, @FUnCenter, 1);

  FNeedUnRadius := 1;
  FUnRadius := FNeedUnRadius;
  FUnCenter[0] := 0.5;
  FUnCenter[1] := 0.5;
  FUnRatio[0] := TheEngine.CurrentResolution.X / TheEngine.CurrentResolution.Y;
  FUnRatio[1] := 1;
end;

procedure TGameScene.OnInitialize(AParameter: TObject);
var
  UnitSide: TLifeFraction;
begin
  TheEngine.Camera := FMainCamera;
  FStartAnimation := 1;
  FShowMap := 1;

  TObjectManager.GetInstance.ClearObjects();

  FHeroShip := THeroShip.CreateUnit(ZeroVectorF, Random(360), lfGreen);
  if (AParameter is TStarSystem) then
    TSystemGenerator.GenerateSystem(FHeroShip, TStarSystem(AParameter));

  if (AParameter is TStarSystem) then
  begin
    case (AParameter as TStarSystem).Size of
      ssSmall: FNeedUnRadius := 1.1 * 3300 * 0.6 / FMainCamera.Resolution.Y;
      ssMedium: FNeedUnRadius := 1.1 * 3300 * 1 / FMainCamera.Resolution.Y;
      ssBig: FNeedUnRadius := 1.1 * 3300 * 1.3 / FMainCamera.Resolution.Y;
    end;
    FUnRadius := FNeedUnRadius;
  end;
end;

procedure TGameScene.OnUpdate(const ADelta: Double);
begin
  THero.GetInstance.UpdateTransPower(3 * ADelta);
  UpdateStartAnimation(ADelta);
  ShowLocalMap();
  FObjectManager.OnUpdate(ADelta);
end;

procedure TGameScene.OnDraw(const ALayer: Integer);
var
  I: Integer;
begin
  TheEngine.Camera := nil;
  TheRender.Rectangle(0, 0,
    TheEngine.CurrentResolution.X, TheEngine.CurrentResolution.Y,
    $FF000000);

  TheRender.SetBlendMode(qbmSrcAlpha);
  TStarFon.Instance.Draw;
  DrawConstrain;

  TheEngine.Camera := FMainCamera;
  FObjectManager.OnDraw;

  //Передавай камеру как-нибудь по другому в апдейт.
  FInterface.OnDraw;
  TheEngine.Camera := FMainCamera;
end;

function TGameScene.OnKeyUp(AKey: Word): Boolean;
var
  I: Word;
  AEnemies: array [0..LIFEFRACTION_COUNT - 1] of Single;
  AResources: Project87.Types.StarMap.TResources;
begin
  Result := False;
  if AKey = KB_E then
    THero.GetInstance.RecoveryHealth;
  if (AKey = KB_BACKSPACE) or (AKey = KB_ESC) then
    BackToMap;
  if THero.GetInstance.IsDead  and (AKey = KB_SPACE) then
    BackToMap;
end;

procedure TGameScene.UpdateStartAnimation(const ADelta: Double);
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
end;

procedure TGameScene.ShowLocalMap;
begin
  if (TheControlState.Keyboard.IsKeyPressed[KB_TAB]) then
  begin
    if (FShowMap > 0.1) then
    begin
      FShowMap := FShowMap * 0.85;
      if FShowMap < 0.1 then
        FShowMap := 0.1;
      FMainCamera.Scale := Vec2F(FShowMap, FShowMap);
    end;
  end
  else
    if (FShowMap < 1) then
    begin
      FShowMap := FShowMap * 1.1;
      if FShowMap > 1 then
        FShowMap := 1;
      FMainCamera.Scale := Vec2F(FShowMap, FShowMap);
    end;
end;

procedure TGameScene.PrepareConstrainData;
var
  ACenter: TVectorF;
begin
  ACenter := FMainCamera.GetScreenPos(ZeroVectorF);
  ACenter := ACenter.ComponentwiseDivide(FMainCamera.Resolution);
  FUnCenter[0] := ACenter.X;
  FUnCenter[1] := ACenter.Y;
  FUnRadius := FNeedUnRadius * FMainCamera.Scale.X;
end;

procedure TGameScene.DrawConstrain;
begin
  PrepareConstrainData;
  FUnavailableShader.SetShaderState(True);
    TheEngine.Camera := nil;
    FUnavailableBuffer.Draw(0, 0, $18FF6060);
  FUnavailableShader.SetShaderState(False);
end;

procedure TGameScene.BackToMap;
var
  I: Word;
  AEnemies: Project87.Types.StarMap.TEnemies;
  AResources: Project87.Types.StarMap.TResources;
begin
  THero.GetInstance.RebornPlayer;
  AEnemies := TSystemGenerator.GetLastEnemies;
  AResources := TSystemGenerator.GetRemainingResources;
  FSystemResult := TStarSystemResult.Create(AEnemies, AResources);
  TheSceneManager.MakeCurrent('StarMap');
  TheSceneManager.OnInitialize(FSystemResult);
  FSystemResult := nil;
end;
{$ENDREGION}

end.
