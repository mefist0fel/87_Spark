unit Project87.Types.StarMap;

interface

uses
  Classes,
  Generics.Collections,
  QCore.Types,
  QCore.Input,
  QuadEngine,
  QEngine.Core,
  QEngine.Camera,
  QEngine.Texture,
  QEngine.Font,
  Project87.Fluid,
  Strope.Math;

const
  LIFEFRACTION_COUNT = 3;

type
  TSystemSize = (ssSmall = 0, ssMedium = 1, ssBig = 2);
  TSystemType = (stIce = 0, stStone = 1, stLife = 2);
  TSystemConfiguration = (scDischarged = 0, scCompact = 1, scPlanet = 2);
  TLifeFraction = (lfRed = 0, lfBlue = 1, lfGreen = 2);
  TLifeFractions = set of TLifeFraction;

  TStarSystemResult = class sealed
    strict private
      FEnemies: array [0..LIFEFRACTION_COUNT - 1] of Single;
      FResources: array [0..FLUID_TYPE_COUNT - 1] of Single;

      function GetEnemies(AIndex: Integer): Single;
      function GetResources(AIndex: Integer): Single;
    public
      constructor Create(AEnemies, AResources: array of Single);

      property Enemies[AIndex: Integer]: Single read GetEnemies;
      property Resources[AIndex: Integer]: Single read GetResources;
  end;

  TStarMap = class;

  TStarSystem = class sealed
    strict private
      FId: TObjectId;
      FSector: TVectorI;

      FIsOpened: Boolean;
      FPosition: TVectorF;

      FSize: TSystemSize;
      FType: TSystemType;
      FConfiguration: TSystemConfiguration;
      FFractions: TLifeFractions;
      FSeed: Integer;
      FLifeSeed: Integer;

      FIsInfoHided: Boolean;
      FSizeFactor: Single;
      FRadius, FResourcesRadius, FNeedRadius: Single;
      FEnemyRadius, FNeedEnemyRadius: Single;
      FEnemySize: array [0..LIFEFRACTION_COUNT - 1] of Single;
      FEnemyColor: array [0..LIFEFRACTION_COUNT - 1] of Cardinal;
      FEnemyCount: Integer;
      FAngles: array [0..3] of Single;
      FNeedAngles: array [0..3] of Single;
      FIsShow, FIsHide: Boolean;
      FAlpha, FEnemyAngle: Single;
      FTime: Single;
    private
      FEnemies: array [0..LIFEFRACTION_COUNT - 1] of Single;
      FResources: array [0..FLUID_TYPE_COUNT - 1] of Single;
      
      constructor Create;

      procedure Generate(const ASector: TVector2I);
      procedure LoadFromStream(AStream: TFileStream);
      procedure SaveToStream(AStream: TFileStream);
      function IsContains(const APoint: TVectorF): Boolean;

      procedure CheckSize;
      procedure CheckEnemies;
      procedure CheckResources;
      procedure ShowInfo;
      procedure HideInfo;

      function GetEdgeColor(AOwner: TStarMap): Cardinal;
      procedure Draw(AOwner: TStarMap);
      procedure Update(ADelta: Double);

      function GetEnemies(AIndex: Integer): Single;
      function GetResources(AIndex: Integer): Single;

      property IsOpened: Boolean read FIsOpened write FIsOpened;
      property IsInfoHided: Boolean read FIsInfoHided;
      property SizeFactor: Single read FSizeFactor;
    public
      property Id: TObjectId read FId;
      property Sector: TVectorI read FSector;
      property Position: TVectorF read FPosition;

      property Size: TSystemSize read FSize;
      property SystemType: TSystemType read FType;
      property Configuration: TSystemConfiguration read FConfiguration;
      property Fractions: TLifeFractions read FFractions;
      property Seed: Integer read FSeed;
      property LifeSeed: Integer read FSeed;
      property Enemies[AIndex: Integer]: Single read GetEnemies;
      property Resources[AIndex: Integer]: Single read GetResources;
  end;

  TStarMap = class sealed (TComponent)
    strict private
      class var FIdCounter: TObjectId;

      FSectors: TList<TVectorI>;
      FSystems: TList<TStarSystem>;
      FCurrentSystem: TStarSystem;
      FSelectedSystem: TStarSystem;
      FInfoSystem: TStarSystem;

      FStar: TQuadTexture;
      FMarkerLine: TQuadTexture;

      FIsTransition: Boolean;
      FIsBack: Boolean;
      FIsEnter: Boolean;
      FTime: Single;
      FCamera: IQuadCamera;

      procedure SetupShader;
      procedure FillFirst;
      function ChessDistation(const A, B: TVectorI): Integer;
      function IsHaveAllNeighbors(const ASector: TVectorI): Boolean;
      procedure GenerateSystems(const ASector: TVectorI);
      procedure GenerateMissingSectors(const ASector: TVectorI);
      procedure CheckNeedSectors;
      procedure EnterToSystem;
      procedure TransitionToSelected;
      function CheckDistance(const A, B: TVectorF;
        AMaxDistance: Single): Boolean;
      function CheckSystemDistance(A, B: TStarSystem;
        AMaxDistance: Single): Boolean;
      procedure PrepareCamera;

      function IsOnScreen(ASystem: TStarSystem): Boolean;
      procedure DrawSystem(ASystem: TStarSystem);
      procedure DrawSystemInfo;
      procedure DrawCurtain;

      function GetSelectedSystem(): TStarSystem;
      function GetCurrentSystem(): TStarSystem;
    private
      FMarkerType: TQuadTexture;
      FMarkerContour: TQuadTexture;
      FMarkerEnemy: TQuadTexture;
      FNeedDraw: TList<TStarSystem>;

      FInfoShader: IQuadShader;
      FInfoRadius: array [0..1] of Single;
      FInfoAngles: array [0..3] of Single;
      FColorY: array [0..3] of Single;
      FColorG: array [0..3] of Single;
      FColorB: array [0..3] of Single;
      FColorR: array [0..3] of Single;

      class procedure TakeId(Id: TObjectId);
      class function GetNewId(): TObjectId;

      property SelectedSystem: TStarSystem read GetSelectedSystem;
      property CurrentSystem: TStarSystem read GetCurrentSystem;
    public
      class constructor CreateClass;

      constructor Create;
      destructor Destroy; override;

      procedure Clear;
      procedure BackToMap(AResult: TStarSystemResult = nil);
      procedure LoadFromFile(const AFile: string);
      procedure SaveToFile(const AFile: string);

      ///<summary>Производит вервичное заполнение мира
      /// звёздными системами.</summary>
      procedure OnInitialize(AParameter: TObject = nil); override;
      procedure OnDraw(const ALayer: Integer); override;
      procedure OnUpdate(const ADelta: Double); override;

      function OnMouseMove(const AMousePosition: TVectorF): Boolean; override;
      function OnMouseButtonUp(AButton: TMouseButton;
        const AMousePosition: TVectorF): Boolean; override;
      function OnKeyUp(AKey: TKeyButton): Boolean; override;
  end;

implementation

uses
  SysUtils,
  Math,
  direct3d9,
  QGame.Game,
  QGame.Resources,
  Project87.Resources;

const
  SECTOR_SIZE = 2048;
  SYSTEMS_IN_SECTOR = 180;
  SYSTEM_SIZE = 12;
  MAX_DISTANCE = 320;
  TRANSITION_TIME = 0.6;
  BACK_TO_MAP_TIME = 0.6;
  ENTER_TO_SYSTEM_TIME = 0.6;
  SystemSize: TVectorF = (X: SYSTEM_SIZE; Y: SYSTEM_SIZE);

  SYSTEM_INFO_SIZE = 4.5;
  SHOW_INFO_TIME = 0.4;
  HIDE_INFO_TIME = 0.25;
  ENEMY_ROTATION_SPEED = 45;
  ENEMY_SIZE = 20;

{$REGION '  TStarSystemResult  '}
constructor TStarSystemResult.Create(AEnemies, AResources: array of Single);
var
  I: Integer;
begin
  for I := 0 to LIFEFRACTION_COUNT - 1 do
    FEnemies[I] := AEnemies[I];
  for I := 0 to FLUID_TYPE_COUNT - 1 do
    FResources[I] := AResources[I];
end;

function TStarSystemResult.GetEnemies(AIndex: Integer): Single;
begin
  if (AIndex < 0) or (AIndex >= LIFEFRACTION_COUNT) then
    Exit(0);
  Result := FEnemies[AIndex];
end;

function TStarSystemResult.GetResources(AIndex: Integer): Single;
begin
  if (AIndex < 0) or (AIndex >= FLUID_TYPE_COUNT) then
    Exit(0);
  Result := FResources[AIndex];
end;
{$ENDREGION}

{$REGION '  TStarSystem  '}
constructor TStarSystem.Create;
begin
  FId := TStarMap.GetNewId;
  FIsInfoHided := True;
  FEnemyAngle := 0;
end;

procedure TStarSystem.Generate(const ASector: TVectorI);
var
  AFromX, AFromY: Single;
  AX, AY: Single;
  I: Integer;
begin
  FSector := ASector;

  AFromX := (ASector.X - 0.5) * SECTOR_SIZE;
  AFromY := (ASector.Y - 0.5) * SECTOR_SIZE;
  AX := AFromX + SECTOR_SIZE * Random;
  AY := AFromY + SECTOR_SIZE * Random;
  FPosition := Vec2F(AX, AY);
  FIsOpened := False;
  for I := 0 to FLUID_TYPE_COUNT - 1 do
    FResources[I] := 1;
  for I := 0 to LIFEFRACTION_COUNT - 1 do
    FEnemies[I] := 1;

  FSeed := Random(High(Integer));
  FLifeSeed := Random(High(Integer));

  FSize := TSystemSize(Random(3));
  FType := TSystemType(Random(3));
  FConfiguration := TSystemConfiguration(Random(3));

  FFractions := [TLifeFraction(Random(3))];
  if Random(10) = 0 then
    Include(FFractions, TLifeFraction(lfRed));
  if Random(10) = 4 then
    Include(FFractions, TLifeFraction(lfGreen));
  if Random(10) = 7 then
    Include(FFractions, TLifeFraction(lfRed));
end;

function TStarSystem.GetEnemies(AIndex: Integer): Single;
begin
  if (AIndex < 0) or (AIndex >= LIFEFRACTION_COUNT) then
    Exit(0);
  Result := FEnemies[AIndex];
end;

function TStarSystem.GetResources(AIndex: Integer): Single;
begin
  if (AIndex < 0) or (AIndex >= FLUID_TYPE_COUNT) then
    Exit(0);
  Result := FResources[AIndex];
end;

procedure TStarSystem.LoadFromStream(AStream: TFileStream);
var
  ABooleanBuf: Boolean;
  I: Integer;
begin
  AStream.Read(FId, SizeOf(FId));
  TStarMap.TakeId(FId);

  AStream.Read(FSeed, SizeOf(FSeed));
  AStream.Read(FLifeSeed, SizeOf(FLifeSeed));
  AStream.Read(FSize, SizeOf(FSize));
  AStream.Read(FType, SizeOf(FType));
  AStream.Read(FConfiguration, SizeOf(FConfiguration));
  AStream.Read(FIsOpened, SizeOf(FIsOpened));
  AStream.Read(FPosition, SizeOf(FPosition));
  AStream.Read(FSector, SizeOf(FSector));

  for I := 0 to LIFEFRACTION_COUNT - 1 do
    AStream.Read(FEnemies[I], SizeOf(FEnemies[I]));
  for I := 0 to FLUID_TYPE_COUNT - 1 do
    AStream.Read(FResources[I], SizeOf(FResources[I]));

  FFractions := [];
  AStream.Read(ABooleanBuf, SizeOf(ABooleanBuf));
  if ABooleanBuf then
    Include(FFractions, lfRed);
  AStream.Read(ABooleanBuf, SizeOf(ABooleanBuf));
  if ABooleanBuf then
    Include(FFractions, lfBlue);
  AStream.Read(ABooleanBuf, SizeOf(ABooleanBuf));
  if ABooleanBuf then
    Include(FFractions, lfGreen);
end;

procedure TStarSystem.SaveToStream(AStream: TFileStream);
var
  ABooleanBuf: Boolean;
  I: Integer;
begin
  AStream.Write(FId, SizeOf(FId));
  AStream.Write(FSeed, SizeOf(FSeed));
  AStream.Write(FLifeSeed, SizeOf(FLifeSeed));
  AStream.Write(FSize, SizeOf(FSize));
  AStream.Write(FType, SizeOf(FType));
  AStream.Write(FConfiguration, SizeOf(FConfiguration));
  AStream.Write(FIsOpened, SizeOf(FIsOpened));
  AStream.Write(FPosition, SizeOf(FPosition));
  AStream.Write(FSector, SizeOf(FSector));

  for I := 0 to LIFEFRACTION_COUNT - 1 do
    AStream.Write(FEnemies[I], SizeOf(FEnemies[I]));
  for I := 0 to FLUID_TYPE_COUNT - 1 do
    AStream.Write(FResources[I], SizeOf(FResources[I]));

  ABooleanBuf := lfRed in FFractions;
  AStream.Write(ABooleanBuf, SizeOf(ABooleanBuf));
  ABooleanBuf := lfBlue in FFractions;
  AStream.Write(ABooleanBuf, SizeOf(ABooleanBuf));
  ABooleanBuf := lfGreen in FFractions;
  AStream.Write(ABooleanBuf, SizeOf(ABooleanBuf));
end;

function TStarSystem.IsContains(const APoint: TVector2F): Boolean;
begin
  Result := Distance(FPosition, APoint) < 2 * SYSTEM_SIZE;
end;

procedure TStarSystem.CheckSize;
begin
  case FSize of
    ssSmall: FSizeFactor := 0.7;
    ssMedium: FSizeFactor := 1;
    ssBig: FSizeFactor := 1.3;
  end;
end;

procedure TStarSystem.CheckEnemies;
var
  I: Integer;
begin
  FEnemyCount := 0;
  for I := 0 to LIFEFRACTION_COUNT - 1 do
    if TLifeFraction(I) in FFractions then
    begin
      if FIsOpened then
        FEnemySize[FEnemyCount] := Clamp(FEnemies[I], 1, 0)
      else
        FEnemySize[FEnemyCount] := 1;

      case I of
        0: FEnemyColor[FEnemyCount] := $FF4020;
        1: FEnemyColor[FEnemyCount] := $20FF30;
        2: FEnemyColor[FEnemyCount] := $2040FF;
      end;
      Inc(FEnemyCount);
    end;
end;

procedure TStarSystem.CheckResources;
begin
  if FIsOpened then
  begin
    FNeedAngles[0] := 2 * Pi * FResources[0] / 4;
    FNeedAngles[1] := FNeedAngles[0] + 2 * Pi * FResources[1] / 4;
    FNeedAngles[2] := FNeedAngles[1] + 2 * Pi * FResources[2] / 4;
    FNeedAngles[3] := FNeedAngles[2] + 2 * Pi * FResources[3] / 4;
  end
  else
  begin
    FNeedAngles[0] := 0;
    FNeedAngles[1] := 0;
    FNeedAngles[2] := 0;
    FNeedAngles[3] := 0;
  end;
end;

procedure TStarSystem.ShowInfo;
begin
  FIsInfoHided := False;
  FIsShow := True;
  CheckEnemies;
  CheckSize;
  FNeedRadius := 0.5;
  FNeedEnemyRadius := SYSTEM_SIZE * SYSTEM_INFO_SIZE * 1.25;
  CheckResources;
  if FIsHide then
  begin
    FIsHide := False;
    FTime := (1 - FTime / HIDE_INFO_TIME) * SHOW_INFO_TIME;
  end
  else
    FTime := 0;
end;

procedure TStarSystem.HideInfo;
begin
  FIsHide := True;
  CheckEnemies;
  CheckSize;
  FNeedRadius := 0.5;
  FNeedEnemyRadius := SYSTEM_SIZE * SYSTEM_INFO_SIZE * 1.25;
  CheckResources;
  if FIsShow then
  begin
    FIsShow := False;
    FTime := (1 - FTime / SHOW_INFO_TIME) * HIDE_INFO_TIME;
  end
  else
    FTime := 0;
end;

function TStarSystem.GetEdgeColor;
begin
  Result := $404040;
  if Self = AOwner.SelectedSystem then
    Result := $806020;
  if Self = AOwner.CurrentSystem then
    Result := $602020;
end;

procedure TStarSystem.Draw(AOwner: TStarMap);
var
  I, J: Integer;
  AVector: TVectorF;
  AColor: Cardinal;
begin
  AColor := GetEdgeColor(AOwner);
  AOwner.FInfoRadius[0] := FResourcesRadius;
  AOwner.FInfoRadius[1] := FRadius;
  for I := 0 to 3 do
    AOwner.FInfoAngles[I] := FAngles[I];

  AOwner.FInfoShader.SetShaderState(True);
    AOwner.FMarkerType.Draw(
      FPosition, SystemSize * SYSTEM_INFO_SIZE * 2 * FSizeFactor,
      0, D3DCOLOR_COLORVALUE(1, 1, 1, FAlpha));
  AOwner.FInfoShader.SetShaderState(False);

  AOwner.FMarkerContour.Draw(
    FPosition, SystemSize * SYSTEM_INFO_SIZE * 4 * FRadius * 0.88 * FSizeFactor,
    0, D3DCOLOR_COLORVALUE(0.1, 0.1, 0.1, FAlpha));
  AOwner.FMarkerContour.Draw(
    FPosition, SystemSize * SYSTEM_INFO_SIZE * 4 * FRadius * 1.025 * FSizeFactor,
    0, AColor + D3DCOLOR_COLORVALUE(0, 0, 0, FAlpha));

  AOwner.FMarkerContour.Draw(
    FPosition, Vec2F(FEnemyRadius, FEnemyRadius) * 2.05 * FSizeFactor,
    0, AColor + D3DCOLOR_COLORVALUE(0, 0, 0, FAlpha * 0.4));
  for I := 0 to FEnemyCount - 1 do
  begin
    for J := 1 to 7 do
    begin
      if (FEnemySize[I] - J / 8) >= 0 then
        AColor := FEnemyColor[I] + D3DCOLOR_COLORVALUE(0, 0, 0, FAlpha)
      else
        AColor := D3DCOLOR_COLORVALUE(0.5, 0.5, 0.5, FAlpha);
      AVector := GetRotatedVector(
        FEnemyAngle + I * 360 / FEnemyCount - 0 - J * 12 * FAlpha,
        FEnemyRadius * FSizeFactor);
      AOwner.FMarkerEnemy.Draw(FPosition + AVector,
          Vec2F(ENEMY_SIZE, ENEMY_SIZE) * FAlpha * (0.7 - 0.4 * J / 8) * FSizeFactor,
          0, AColor)
    end;

    AVector := GetRotatedVector(FEnemyAngle + I * 360 / FEnemyCount, FEnemyRadius * FSizeFactor);
    AOwner.FMarkerEnemy.Draw(FPosition + AVector,
      Vec2F(ENEMY_SIZE, ENEMY_SIZE) * FAlpha * 0.7 * FSizeFactor,
      0, FEnemyColor[I] + D3DCOLOR_COLORVALUE(0, 0, 0, FAlpha));
  end;
end;

procedure TStarSystem.Update(ADelta: Double);
var
  I: Integer;
  AProgress: Single;
begin
  FEnemyAngle := FEnemyAngle + ENEMY_ROTATION_SPEED * ADelta;
  FEnemyAngle := RoundAngle(FEnemyAngle);

  if FIsShow then
  begin
    FTime := FTime + ADelta;
    AProgress := FTime / SHOW_INFO_TIME;
    FAlpha := InterpolateValue(0, 1, AProgress, itLinear);
    FRadius := InterpolateValue(0, FNeedRadius, AProgress, itHermit01);
    FEnemyRadius := InterpolateValue(0, FNeedEnemyRadius, AProgress, itHermit01);
    FResourcesRadius := FRadius * 0.86;
    for I := 0 to 3 do
      FAngles[I] := InterpolateValue(0, FNeedAngles[I], AProgress, itHermit01);
    if FTime > SHOW_INFO_TIME then
    begin
      FRadius := FNeedRadius;
      FResourcesRadius := FRadius * 0.86;
      for I := 0 to 3 do
        FAngles[I] := FNeedAngles[I];
      FIsShow := False;
      FTime := 0;
    end;
  end;

  if FIsHide then
  begin
    FTime := FTime + ADelta;
    AProgress := FTime / HIDE_INFO_TIME;
    FAlpha := InterpolateValue(1, 0, AProgress, itLinear);
    FRadius := InterpolateValue(FNeedRadius, 0, AProgress, itHermit01);
    FEnemyRadius := InterpolateValue(FNeedEnemyRadius, 0, AProgress, itHermit01);
    FResourcesRadius := FRadius * 0.86;
    for I := 0 to 3 do
      FAngles[I] := InterpolateValue(FNeedAngles[I], 0, AProgress, itHermit01);
    if FTime > HIDE_INFO_TIME then
    begin
      FIsHide := False;
      FIsInfoHided := True;
      FTime := 0;
    end;
  end;
end;
{$ENDREGION}

{$REGION '  TStarMap  '}
class constructor TStarMap.CreateClass;
begin
  //0 - аналог nil
  FIdCounter := 1;
end;

class procedure TStarMap.TakeId(Id: Cardinal);
begin
  if FIdCounter <= Id then
    FIdCounter := Id + 1;
end;

class function TStarMap.GetNewId;
begin
  Result := FIdCounter;
  Inc(FIdCounter);
end;

constructor TStarMap.Create;
begin
  FSectors := TList<TVectorI>.Create;
  FSystems := TList<TStarSystem>.Create;
  FNeedDraw := TList<TStarSystem>.Create;
  FCurrentSystem := nil;
  FSelectedSystem := nil;
  FInfoSystem := nil;

  FStar :=
    (TheResourceManager.GetResource('Image', 'SimpleStarMarker') as TTextureExResource).Texture;
  FMarkerLine :=
    (TheResourceManager.GetResource('Image', 'MarkerLine') as TTextureExResource).Texture;
  FMarkerType :=
    (TheResourceManager.GetResource('Image', 'SystemInfo') as TTextureExResource).Texture;
  FMarkerContour :=
    (TheResourceManager.GetResource('Image', 'SystemEdge') as TTextureExResource).Texture;
  FMarkerEnemy :=
    (TheResourceManager.GetResource('Image', 'SystemEnemy') as TTextureExResource).Texture;

  SetupShader;

  FIsTransition := False;
  FIsEnter := False;
  FIsBack := False;
  FCamera := TheEngine.CreateCamera;
end;

destructor TStarMap.Destroy;
var
  ASystem: TStarSystem;
begin
  for ASystem in FSystems do
    ASystem.Free;
  FSystems.Free;
  FSectors.Free;

  inherited;
end;

procedure TStarMap.SetupShader;
begin
  TheDevice.CreateShader(FInfoShader);
  FInfoShader.LoadPixelShader('..\data\shd\systeminfo.bin');
  FInfoShader.BindVariableToPS(1, @FInfoRadius, 1);
  FInfoShader.BindVariableToPS(2, @FInfoAngles, 1);
  FInfoShader.BindVariableToPS(3, @FColorY, 1);
  FInfoShader.BindVariableToPS(4, @FColorG, 1);
  FInfoShader.BindVariableToPS(5, @FColorB, 1);
  FInfoShader.BindVariableToPS(6, @FColorR, 1);

  FColorY[0] := 1;
  FColorY[1] := 0.9;
  FColorY[2] := 0.2;
  FColorY[3] := 1;

  FColorG[0] := 0.2;
  FColorG[1] := 1;
  FColorG[2] := 0.2;
  FColorG[3] := 1;

  FColorB[0] := 0.1;
  FColorB[1] := 0.4;
  FColorB[2] := 1;
  FColorB[3] := 1;

  FColorR[0] := 1;
  FColorR[1] := 0.3;
  FColorR[2] := 0.2;
  FColorR[3] := 1;
end;

function TStarMap.GetSelectedSystem;
begin
  Result := FSelectedSystem;
end;

function TStarMap.GetCurrentSystem;
begin
  Result := FCurrentSystem;
end;

procedure TStarMap.Clear;
begin
  FSelectedSystem := nil;
  FCurrentSystem := nil;
  FInfoSystem := nil;
  FSectors.Clear;
  FSystems.Clear;
  FNeedDraw.Clear;
end;

procedure TStarMap.LoadFromFile(const AFile: string);
var
  AStream: TFileStream;
  I: Integer;
  AId: TObjectId;
  ASectorsCount: Integer;
  ASystemsCount: Integer;
  AVectorIBuf: TVectorI;
  ASystem: TStarSystem;
begin
  Clear;
  AStream := TFileStream.Create(AFile, fmOpenRead);
    AStream.Read(AId, SizeOf(AId));
    AStream.Read(ASectorsCount, SizeOf(ASectorsCount));
    AStream.Read(ASystemsCount, SizeOf(ASystemsCount));

    for I := 0 to ASectorsCount - 1 do
    begin
      AStream.Read(AVectorIBuf, SizeOf(AVectorIBuf));
      FSectors.Add(AVectorIBuf);
    end;

    for I := 0 to ASystemsCount - 1 do
    begin
      ASystem := TStarSystem.Create;
      ASystem.LoadFromStream(AStream);
      if AId = ASystem.Id then
        FCurrentSystem := ASystem;
      FSystems.Add(ASystem);
    end;
  AStream.Free;
end;

procedure TStarMap.SaveToFile(const AFile: string);
var
  AStream: TFileStream;
  I: Integer;
  AId: TObjectId;
  ASectorsCount: Integer;
  ASystemsCount: Integer;
  AVectorIBuf: TVectorI;
  ASystem: TStarSystem;
begin
  AStream := TFileStream.Create(AFile, fmOpenWrite);
    AId := FCurrentSystem.Id;
    AStream.Write(AId, SizeOf(AId));

    ASectorsCount := FSectors.Count;
    AStream.Write(ASectorsCount, SizeOf(ASectorsCount));

    ASystemsCount := FSystems.Count;
    AStream.Write(ASystemsCount, SizeOf(ASystemsCount));

    for I := 0 to ASectorsCount - 1 do
    begin
      AVectorIBuf := FSectors[I];
      AStream.Write(AVectorIBuf, SizeOf(AVectorIBuf));
    end;

    for I := 0 to ASystemsCount - 1 do
    begin
      ASystem := FSystems[I];
      ASystem.SaveToStream(AStream);
    end;
  AStream.Free;
end;

function TStarMap.ChessDistation(const A, B: TVectorI): Integer;
begin
  Result := Max(Abs(A.X - B.X), Abs(A.Y - B.Y));
end;

function TStarMap.IsHaveAllNeighbors(const ASector: TVectorI): Boolean;
var
  ANeighborsCount: Integer;
  AItem: TVectorI;
begin
  ANeighborsCount := 0;
  for AItem in FSectors do
    if ChessDistation(ASector, AItem) = 1 then
      Inc(ANeighborsCount);
  Result := ANeighborsCount = 8;
end;

procedure TStarMap.GenerateSystems(const ASector: TVectorI);
var
  I: Integer;
  ASystem, AOtherSystem: TStarSystem;
  AFlag: Boolean;
begin
  FSectors.Add(ASector);
  for I := 0 to SYSTEMS_IN_SECTOR - 1 do
  begin
    ASystem := TStarSystem.Create;
    while True do
    begin
      ASystem.Generate(ASector);

      AFlag := False;
      for AOtherSystem in FSystems do
      begin
        if ChessDistation(ASystem.Sector, AOtherSystem.Sector) > 1 then
          Continue;

        if ASystem.Position.Distance(AOtherSystem.Position) < 5 * SYSTEM_SIZE then
        begin
          AFlag := True;
          Break;
        end;
      end;

      if not AFlag then
        Break;
    end;
    FSystems.Add(ASystem);
  end;
end;

procedure TStarMap.GenerateMissingSectors(const ASector: TVectorI);
var
  AValue: TVectorI;
  I, J: Integer;
begin
  for I := -1 to 1 do
    for J := -1 to 1 do
    begin
      if (I = 0) and (J = 0) then
        Continue;
      AValue := ASector + Vec2I(I, J);
      if not FSectors.Contains(AValue) then
        GenerateSystems(AValue);
    end;
end;

procedure TStarMap.CheckNeedSectors;
begin
  if not IsHaveAllNeighbors(FSelectedSystem.Sector) then
    GenerateMissingSectors(FSelectedSystem.Sector);
end;

procedure TStarMap.TransitionToSelected;
begin
  CheckNeedSectors;
  FCurrentSystem := FSelectedSystem;
  FSelectedSystem := nil;
end;

function TStarMap.CheckDistance(const A, B: TVectorF;
  AMaxDistance: Single): Boolean;
begin
  Result := A.Distance(B) <= AMaxDistance;
end;

function TStarMap.CheckSystemDistance(A, B: TStarSystem;
  AMaxDistance: Single): Boolean;
begin
  Result := A.Position.Distance(B.Position) <= AMaxDistance;
end;

procedure TStarMap.FillFirst;
var
  I, J: Integer;
begin
  for I := -1 to 1 do
    for J := -1 to 1 do
    begin
      GenerateSystems(Vec2I(I, J));
      if (I = 0) and (J = 0) then
        FCurrentSystem := FSystems.Last;
    end;
end;

procedure TStarMap.BackToMap;
var
  I: Integer;
begin
  if FCurrentSystem = nil then
    Clear;
  if Assigned(AResult) then
  begin
    FCurrentSystem.IsOpened := True;
    for I := 0 to LIFEFRACTION_COUNT - 1 do
      FCurrentSystem.FEnemies[I] := AResult.Enemies[I];
    for I := 0 to FLUID_TYPE_COUNT - 1 do
      FCurrentSystem.FResources[I] := AResult.Resources[I];

    FreeAndNil(AResult);
  end;

  FSelectedSystem := nil;
  FInfoSystem := nil;
  FIsBack := True;
  FTime := 0;
end;

procedure TStarMap.EnterToSystem;
begin
  TheSceneManager.MakeCurrent('Spark');
  TheSceneManager.OnInitialize(FCurrentSystem);
end;

procedure TStarMap.OnInitialize(AParameter: TObject);
begin
  FillFirst;
end;

procedure TStarMap.PrepareCamera;
var
  AScale: TVectorF;
begin
  TheEngine.Camera := FCamera;
  if FIsTransition then
    FCamera.Position := FCurrentSystem.Position.InterpolateTo(
      FSelectedSystem.Position, FTime / TRANSITION_TIME, itHermit01)
  else
    FCamera.Position := FCurrentSystem.Position;

  if FIsBack then
  begin
    AScale := Vec2F(60, 60);
    AScale := AScale.InterpolateTo(
      Vec2F(1, 1), FTime / BACK_TO_MAP_TIME, itHermit01);
    FCamera.Scale := AScale;
    Exit;
  end
  else
    FCamera.Scale := Vec2F(1, 1);

  if FIsEnter then
  begin
    AScale := Vec2F(1, 1);
    AScale := AScale.InterpolateTo(
      Vec2F(60, 60), FTime / ENTER_TO_SYSTEM_TIME, itHermit01);
    FCamera.Scale := AScale;
    Exit;
  end
  else
    FCamera.Scale := Vec2F(1, 1);
end;

function TStarMap.IsOnScreen(ASystem: TStarSystem): Boolean;
var
  APosition: TVectorF;
begin
  APosition := FCamera.GetScreenPos(ASystem.Position);
  Result := (APosition.X > -2 * SYSTEM_SIZE) and (APosition.Y > -2 * SYSTEM_SIZE) and
    (APosition.X < FCamera.Resolution.X + 2 * SYSTEM_SIZE) and
    (APosition.Y < FCamera.Resolution.Y + 2 * SYSTEM_SIZE);
end;

procedure TStarMap.DrawSystem(ASystem: TStarSystem);
var
  AColor: Cardinal;
begin
  AColor := $FFFFFFFF;
  if ASystem = FCurrentSystem then
    AColor := $FFFF8080;
  if ASystem = FSelectedSystem then
    AColor := $FFFFB080;
  if not CheckDistance(FCamera.Position, ASystem.Position, MAX_DISTANCE) then
    AColor := $FF808080;
  FStar.Draw(ASystem.Position, SystemSize, 0, AColor);
end;

procedure TStarMap.DrawSystemInfo;
var
  ASystem: TStarSystem;
begin
  for ASystem in FNeedDraw do
    ASystem.Draw(Self);
  if Assigned(FInfoSystem) then
    FInfoSystem.Draw(Self);
end;

procedure TStarMap.DrawCurtain;
var
  AAlpha: Single;
begin
  AAlpha := 0;
  if FIsEnter then
    AAlpha := InterpolateValue(0, 1, FTime / ENTER_TO_SYSTEM_TIME, itParabolic01);
  if FIsBack then
    AAlpha := InterpolateValue(1, 0, FTime / BACK_TO_MAP_TIME, itParabolic01);

  TheEngine.Camera := nil;
  TheRender.Rectangle(0, 0, FCamera.Resolution.X, FCamera.Resolution.Y,
    D3DCOLOR_COLORVALUE(0, 0, 0, AAlpha));
end;

procedure TStarMap.OnDraw(const ALayer: Integer);
var
  ASystem: TStarSystem;
  APosition, ASize: TVectorF;
  AAngle: Single;
  AAlpha: Single;
begin
  PrepareCamera;

  TheRender.SetBlendMode(qbmSrcAlpha);
  TheResources.AsteroidTexture.Draw(FCamera.Position,
    Vec2F(MAX_DISTANCE, MAX_DISTANCE) * 2, 0, $30FF4040);
  for ASystem in FSystems do
    if IsOnScreen(ASystem) then
      DrawSystem(ASystem);
  DrawSystemInfo;
  DrawCurtain;
end;

procedure TStarMap.OnUpdate(const ADelta: Double);
var
  ASystem: TStarSystem;
begin
  if FIsTransition then
  begin
    FTime := FTime + ADelta;
    if FTime > TRANSITION_TIME then
    begin
      FIsTransition := False;
      TransitionToSelected;
    end;
  end;

  if FIsBack then
  begin
    FTime := FTime + ADelta;
    if FTime > BACK_TO_MAP_TIME then
      FIsBack := False;
  end;

  if FIsEnter then
  begin
    FTime := FTime + ADelta;
    if FTime > ENTER_TO_SYSTEM_TIME then
    begin
      FIsEnter := False;
      EnterToSystem;
    end;
  end;

  for ASystem in FNeedDraw do
  begin
    ASystem.Update(ADelta);
    if ASystem.IsInfoHided then
      FNeedDraw.Remove(ASystem);
  end;
  if Assigned(FInfoSystem) then
    FInfoSystem.Update(ADelta);
end;

function TStarMap.OnMouseMove(const AMousePosition: TVectorF): Boolean;
var
  ASystem: TStarSystem;
  ASPosition, AWPosition: TVectorF;
begin
  Result := True;
  if FIsTransition or FIsBack or FIsEnter then
    Exit;

  AWPosition := FCamera.GetWorldPos(AMousePosition);
  for ASystem in FSystems do
  begin
    if ChessDistation(ASystem.Sector, FCurrentSystem.Sector) > 1 then
      Continue;

    if IsOnScreen(ASystem) then
      if ASystem.IsContains(AWPosition) and
        CheckDistance(ASystem.Position, FCurrentSystem.Position, MAX_DISTANCE) and
        (ASystem <> FInfoSystem)
      then
      begin
        if Assigned(FInfoSystem) then
        begin
          FInfoSystem.HideInfo;
          FNeedDraw.Add(FInfoSystem);
        end;
        FInfoSystem := ASystem;
        ASystem.ShowInfo;
        Break;
      end;
  end;

  if Assigned(FInfoSystem) and
    (FInfoSystem.Position.Distance(AWPosition) > SYSTEM_SIZE * SYSTEM_INFO_SIZE * FInfoSystem.SizeFactor)
  then
  begin
    FInfoSystem.HideInfo;
    FNeedDraw.Add(FInfoSystem);
    FInfoSystem := nil;
  end;
end;

function TStarMap.OnMouseButtonUp(AButton: TMouseButton;
  const AMousePosition: TVectorF): Boolean;
var
  ASystem: TStarSystem;
  ASPosition, AWPosition: TVectorF;
begin
  Result := True;
  if FIsTransition or FIsBack or FIsEnter then
    Exit;

  AWPosition := FCamera.GetWorldPos(AMousePosition);
  if Assigned(FInfoSystem) and
    (FInfoSystem.Position.Distance(AWPosition) < SYSTEM_SIZE * SYSTEM_INFO_SIZE) and
    (AButton = mbLeft)
  then
  begin
    if FInfoSystem = FCurrentSystem then
    begin
      FIsEnter := True;
      FTime := 0;
      Exit;
    end;

    if FInfoSystem = FSelectedSystem then
    begin
      FInfoSystem.HideInfo;
      FNeedDraw.Add(FInfoSystem);
      FInfoSystem := nil;

      FIsTransition := True;
      FTime := 0;
    end
    else
      FSelectedSystem := FInfoSystem;
  end;
end;

function TStarMap.OnKeyUp(AKey: TKeyButton): Boolean;
begin
  Result := True;
  if FIsTransition or FIsBack or FIsEnter then
    Exit;

  if AKey = KB_ENTER then
  begin
    FIsEnter := True;
    FTime := 0;
  end;

  if AKey = KB_SPACE then
  begin
    FIsTransition := True;
    FTime := 0;
  end;
end;
{$ENDREGION}

end.
