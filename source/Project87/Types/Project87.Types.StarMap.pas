unit Project87.Types.StarMap;

interface

uses
  Classes,
  Generics.Collections,
  QCore.Types,
  QCore.Input,
  QEngine.Core,
  QEngine.Camera,
  QEngine.Texture,
  QEngine.Font,
  Strope.Math;

type
  TSystemSize = (ssSmall = 0, ssMedium = 1, ssBig = 2);
  TSystemType = (stIce = 0, stStone = 1, stLife = 2);
  TSystemConfiguration = (scDischarged = 0, scCompact = 1, scPlanet = 2);
  TLifeFraction = (lfRed = 0, lfBlue = 1, lfGreen = 2);

  TLifeFractions = set of TLifeFraction;

  TStarSystemResult = class sealed
    strict private
      FEnemies: Single;
      FResources: Single;
    public
      constructor Create(AEnemies, AResources: Single);

      property Enemies: Single read FEnemies;
      property Resources: Single read FResources;
  end;

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
    private
      FEnemies: Single;
      FResources: Single;

      FIsSelected: Boolean;
      FIsFocused: Boolean;

      constructor Create;

      procedure Generate(const ASector: TVector2I);
      procedure LoadFromStream(AStream: TFileStream);
      procedure SaveToStream(AStream: TFileStream);

      function IsContains(const APoint: TVectorF): Boolean;

      property IsOpened: Boolean read FIsOpened write FIsOpened;
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
      property Enemies: Single read FEnemies;
      property Resources: Single read FResources;
  end;

  TStarMap = class sealed (TComponent)
    strict private
      class var FIdCounter: TObjectId;

      FSectors: TList<TVectorI>;

      FSystems: TList<TStarSystem>;
      FCurrentSystem: TStarSystem;
      FSelectedSystem: TStarSystem;
      FInfoSystem: TStarSystem;

      FSmallFont: TQuadFont;
      FStarMarker: TQuadTexture;
      FMarkerLine: TQuadTexture;
      FMarkerArrow: TQuadTexture;

      FIsTransition: Boolean;
      FIsBack: Boolean;
      FIsEnter: Boolean;
      FTime: Single;
      FCamera: IQuadCamera;

      function ChessDistation(const A, B: TVectorI): Integer;
      function IsHaveAllNeighbors(const ASector: TVectorI): Boolean;
      procedure GenerateSystems(const ASector: TVectorI);
      procedure GenerateMissingSectors(const ASector: TVectorI);
      procedure CheckNeedSectors;
      procedure EnterToSystem;
      procedure TransitionToSelected;
      function CheckAvailableDistance(const APoint: TVectorF): Boolean;
      function CheckDistanceToCurrent(ASystem: TStarSystem): Boolean;
      procedure PrepareCamera;
      procedure DrawInfoBox;

      procedure DrawSystemMarker(ASystem: TStarSystem);
    private
      class procedure TakeId(Id: TObjectId);
      class function GetNewId(): TObjectId;
    public
      class constructor CreateClass;

      constructor Create;
      destructor Destroy; override;

      procedure FillFirst;
      procedure BackToMap(AResult: TStarSystemResult = nil);
      procedure LoadFromFile(const AFile: string);
      procedure SaveToFile(const AFile: string);

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
  QuadEngine,
  direct3d9,
  QGame.Game,
  QGame.Resources,
  Project87.Resources;

const
  SECTOR_SIZE = 2048;
  SYSTEMS_IN_SECTOR = 120;
  SYSTEM_SIZE = 12;
  MAX_DISTANCE = 320;
  TRANSITION_TIME = 1.2;
  BACK_TO_MAP_TIME = 0.6;
  ENTER_TO_SYSTEM_TIME = 0.6;

  SystemSize: TVectorF = (X: SYSTEM_SIZE; Y: SYSTEM_SIZE);

{$REGION '  TStarSystemResult  '}
constructor TStarSystemResult.Create(AEnemies, AResources: Single);
begin
  FResources := AResources;
  FEnemies := AEnemies;
end;
{$ENDREGION}

{$REGION '  TStarSystem  '}
constructor TStarSystem.Create;
begin
  FId := 0;
end;

procedure TStarSystem.Generate(const ASector: TVectorI);
var
  AFromX, AFromY: Single;
  AX, AY: Single;
begin
  FId := TStarMap.GetNewId;
  FSector := ASector;

  AFromX := (ASector.X - 0.5) * SECTOR_SIZE;
  AFromY := (ASector.Y - 0.5) * SECTOR_SIZE;
  AX := AFromX + SECTOR_SIZE * Random;
  AY := AFromY + SECTOR_SIZE * Random;
  FPosition := Vec2F(AX, AY);
  FIsOpened := False;

  FSeed := Random(High(Integer));
  FLifeSeed := Random(High(Integer));
  FEnemies := 1;
  FResources := 1;

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

procedure TStarSystem.LoadFromStream(AStream: TFileStream);
var
  ABooleanBuf: Boolean;
begin
  AStream.Read(FId, SizeOf(FId));
  TStarMap.TakeId(FId);

  AStream.Read(FSeed, SizeOf(FSeed));
  AStream.Read(FLifeSeed, SizeOf(FLifeSeed));
  AStream.Read(FEnemies, SizeOf(FEnemies));
  AStream.Read(FResources, SizeOf(FResources));
  AStream.Read(FSize, SizeOf(FSize));
  AStream.Read(FType, SizeOf(FType));
  AStream.Read(FConfiguration, SizeOf(FConfiguration));
  AStream.Read(FisOpened, SizeOf(FIsOpened));
  AStream.Read(FPosition, SizeOf(FPosition));
  AStream.Read(FSector, SizeOf(FSector));

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
begin
  AStream.Write(FId, SizeOf(FId));
  AStream.Write(FSeed, SizeOf(FSeed));
  AStream.Write(FLifeSeed, SizeOf(FLifeSeed));
  AStream.Write(FEnemies, SizeOf(FEnemies));
  AStream.Write(FResources, SizeOf(FResources));
  AStream.Write(FSize, SizeOf(FSize));
  AStream.Write(FType, SizeOf(FType));
  AStream.Write(FConfiguration, SizeOf(FConfiguration));
  AStream.Write(FisOpened, SizeOf(FIsOpened));
  AStream.Write(FPosition, SizeOf(FPosition));
  AStream.Write(FSector, SizeOf(FSector));

  ABooleanBuf := lfRed in FFractions;
  AStream.Write(ABooleanBuf, SizeOf(ABooleanBuf));
  ABooleanBuf := lfBlue in FFractions;
  AStream.Write(ABooleanBuf, SizeOf(ABooleanBuf));
  ABooleanBuf := lfGreen in FFractions;
  AStream.Write(ABooleanBuf, SizeOf(ABooleanBuf));
end;

function TStarSystem.IsContains(const APoint: TVector2F): Boolean;
begin
  Result := Distance(FPosition, APoint) < SYSTEM_SIZE;
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
  FCurrentSystem := nil;
  FSelectedSystem := nil;

  FSmallFont :=
    (TheResourceManager.GetResource('Font', 'Quad_24') as TFontExResource).Font;
  FStarMarker :=
    (TheResourceManager.GetResource('Image', 'SimpleStarMarker') as TTextureExResource).Texture;
  FMarkerLine :=
    (TheResourceManager.GetResource('Image', 'MarkerLine') as TTextureExResource).Texture;
  FMarkerArrow :=
    (TheResourceManager.GetResource('Image', 'MarkerArrow') as TTextureExResource).Texture;

  FIsTransition := False;
  FIsEnter := False;
  FIsBack := True;
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
  ASystem: TStarSystem;
begin
  FSectors.Add(ASector);
  for I := 0 to SYSTEMS_IN_SECTOR - 1 do
  begin
    ASystem := TStarSystem.Create;
    ASystem.Generate(ASector);
    FSystems.Add(ASystem);
  end;
end;

procedure TStarMap.GenerateMissingSectors(const ASector: TVectorI);
var
  I: Integer;
  AValue: TVectorI;
begin
  AValue := ASector + Vec2I(0, 1);
  if not FSectors.Contains(AValue) then
    GenerateSystems(AValue);

  AValue := ASector + Vec2I(0, -1);
  if not FSectors.Contains(AValue) then
    GenerateSystems(AValue);

  AValue := ASector + Vec2I(1, 0);
  if not FSectors.Contains(AValue) then
    GenerateSystems(AValue);

  AValue := ASector + Vec2I(-1, 0);
  if not FSectors.Contains(AValue) then
    GenerateSystems(AValue);

  AValue := ASector + Vec2I(1, 1);
  if not FSectors.Contains(AValue) then
    GenerateSystems(AValue);

  AValue := ASector + Vec2I(-1, -1);
  if not FSectors.Contains(AValue) then
    GenerateSystems(AValue);

  AValue := ASector + Vec2I(-1, 1);
  if not FSectors.Contains(AValue) then
    GenerateSystems(AValue);

  AValue := ASector + Vec2I(1, -1);
  if not FSectors.Contains(AValue) then
    GenerateSystems(AValue);
end;

procedure TStarMap.CheckNeedSectors;
begin
  if not IsHaveAllNeighbors(FSelectedSystem.Sector) then
    GenerateMissingSectors(FSelectedSystem.Sector);
  if not IsHaveAllNeighbors(FCurrentSystem.Sector) then
    GenerateMissingSectors(FCurrentSystem.Sector);
end;

procedure TStarMap.EnterToSystem;
begin
  TheSceneManager.MakeCurrent('Spark');
  TheSceneManager.OnInitialize(FCurrentSystem);
end;

procedure TStarMap.TransitionToSelected;
var
  ASystem: TStarSystem;
begin
  CheckNeedSectors;
  //ASystem := FCurrentSystem;
  FCurrentSystem := FSelectedSystem;
  //FSelectedSystem := ASystem;
  FSelectedSystem := nil;
end;

function TStarMap.CheckAvailableDistance(const APoint: TVectorF): Boolean;
begin
  Result := Distance(FCamera.Position, APoint) <= MAX_DISTANCE
end;

function TStarMap.CheckDistanceToCurrent(ASystem: TStarSystem): Boolean;
begin
  Result := Distance(ASystem.Position, FCurrentSystem.Position) <= MAX_DISTANCE
end;

procedure TStarMap.DrawSystemMarker(ASystem: TStarSystem);
var
  ASize: Single;
  AColor: Cardinal;
begin
  ASize := 1;
  AColor := $FFFFFFFF;

  if ASystem = FCurrentSystem then
  begin
    ASize := 1.3;
    AColor := $FFFF8080;
  end;

  if ASystem = FSelectedSystem then
  begin
    ASize := 1.3;
    AColor := $FFFFB080;
  end;

  if ASystem.FIsFocused then
  begin
    ASize := 1.2;
  end;

  if not CheckAvailableDistance(ASystem.Position) then
    AColor := $FF808080;

  FStarMarker.Draw(ASystem.Position, SystemSize * ASize,
    0, AColor);
end;

procedure TStarMap.FillFirst;
begin
  GenerateSystems(Vec2I(0, 0));
  FCurrentSystem := FSystems[0];

  GenerateSystems(Vec2I(0, 1));
  GenerateSystems(Vec2I(0, -1));
  GenerateSystems(Vec2I(1, 0));
  GenerateSystems(Vec2I(-1, 0));
  GenerateSystems(Vec2I(1, 1));
  GenerateSystems(Vec2I(1, -1));
  GenerateSystems(Vec2I(-1, 1));
  GenerateSystems(Vec2I(-1, -1));
end;

procedure TStarMap.BackToMap;
begin
  if Assigned(AResult) then
  begin
    FCurrentSystem.FEnemies := AResult.Enemies;
    FCurrentSystem.FResources := AResult.Resources;
  end;

  if Assigned(FSelectedSystem) then
    FSelectedSystem.FIsSelected := False;
  FSelectedSystem := nil;
  FInfoSystem := nil;

  FIsBack := True;
  FTime := 0;
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
  AStream := TFileStream.Create(AFile, fmOpenRead);
    AStream.Read(AId, SizeOf(AId));
    AStream.Read(ASectorsCount, SizeOf(ASectorsCount));
    AStream.Read(ASystemsCount, SizeOf(ASystemsCount));

    FSectors.Clear;
    for I := 0 to ASectorsCount - 1 do
    begin
      AStream.Read(AVectorIBuf, SizeOf(AVectorIBuf));
      FSectors.Add(AVectorIBuf);
    end;

    FSystems.Clear;
    for I := 0 to ASystemsCount - 1 do
    begin
      ASystem := TStarSystem.Create;
      ASystem.LoadFromStream(AStream);
      if AId = ASystem.Id then
      begin
        FCurrentSystem := ASystem;
        ASystem.FIsSelected := True;
      end;
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

procedure TStarMap.OnInitialize(AParameter: TObject);
begin

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
    AScale := AScale.InterpolateTo(Vec2F(1, 1), FTime / BACK_TO_MAP_TIME, itHermit01);
    FCamera.Scale := AScale;
    Exit;
  end
  else
    FCamera.Scale := Vec2F(1, 1);

  if FIsEnter then
  begin
    AScale := Vec2F(1, 1);
    AScale := AScale.InterpolateTo(Vec2F(60, 60), FTime / ENTER_TO_SYSTEM_TIME, itHermit01);
    FCamera.Scale := AScale;
    Exit;
  end
  else
    FCamera.Scale := Vec2F(1, 1);
end;

procedure TStarMap.DrawInfoBox;
var
  AString: string;
  APosition: TVectorF;
  ASize: TVectorF;
  ASingle: Single;
begin
  if Assigned(FInfoSystem) then
  begin
    AString := 'System ID - ' + IntToStr(FInfoSystem.Id);
    ASingle := FSmallFont.TextWidth(AString, 1.2);

    APosition := FInfoSystem.Position + SystemSize;
    ASize := Vec2F(ASingle + 3 * SYSTEM_SIZE, 90);
    TheRender.Rectangle(
      APosition.X - 5, APosition.Y - 5,
      APosition.X + ASize.X + 5, APosition.Y + ASize.Y + 5,
      $10FFFFFF);
    TheRender.RectangleEx(
      APosition.X, APosition.Y,
      APosition.X + ASize.X, APosition.Y + ASize.Y,
      $C0606080, $C0606080, $C0202020, $C0202020);

    APosition := APosition + SystemSize;
    FSmallFont.TextOut(AString, APosition, 1.2);

    APosition.Y := APosition.Y + FSmallFont.TextHeight(AString, 1.5);
    APosition.X := APosition.X + 20;
    case FInfoSystem.Size of
      ssSmall: AString := 'Small system';
      ssMedium: AString := 'Medium system';
      ssBig: AString := 'Big system';
    end;
    FSmallFont.TextOut(AString, APosition, 1, $FFFFB000);
  end;
end;

procedure TStarMap.OnDraw(const ALayer: Integer);
var
  ASystem: TStarSystem;
  APosition, ASize: TVectorF;
  AAngle: Single;
  AAlpha: Single;
  AScale: TVectorF;
begin
  PrepareCamera;

  TheRender.SetBlendMode(qbmSrcAlpha);

  TheResources.AsteroidTexture.Draw(FCamera.Position,
    Vec2F(MAX_DISTANCE, MAX_DISTANCE) * 2, 0, $30FF4040);

  if Assigned(FSelectedSystem) then
  begin
    AAngle := GetAngle(FCurrentSystem.Position, FSelectedSystem.Position);
    APosition := FCurrentSystem.Position.InterpolateTo(
      FSelectedSystem.Position, 0.5);
    ASize := Vec2F(
      Distance(FCurrentSystem.Position, FSelectedSystem.Position),
      SYSTEM_SIZE * 0.35);
    FMarkerLine.Draw(APosition, ASize, AAngle - 90, $FFB0B0B0);
  end;

  for ASystem in FSystems do
  begin
    APosition := FCamera.GetScreenPos(ASystem.Position);
    if (APosition.X > -2 * SYSTEM_SIZE) and (APosition.Y > -2 * SYSTEM_SIZE) and
      (APosition.X < FCamera.Resolution.X + 2 * SYSTEM_SIZE) and
      (APosition.Y < FCamera.Resolution.Y + 2 * SYSTEM_SIZE)
    then
    begin
      DrawSystemMarker(ASystem);
    end;
  end;

  DrawInfoBox;

  AAlpha := 0;
  if FIsEnter then
    AAlpha := InterpolateValue(0, 1, FTime / ENTER_TO_SYSTEM_TIME, itParabolic01);
  if FIsBack then
    AAlpha := InterpolateValue(1, 0, FTime / BACK_TO_MAP_TIME, itParabolic01);

  TheEngine.Camera := nil;
  TheRender.Rectangle(0, 0, FCamera.Resolution.X, FCamera.Resolution.Y,
    D3DCOLOR_COLORVALUE(0, 0, 0, AAlpha));
end;

procedure TStarMap.OnUpdate(const ADelta: Double);
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
end;

function TStarMap.OnMouseMove(const AMousePosition: TVectorF): Boolean;
var
  ASystem: TStarSystem;
  ASPosition, AWPosition: TVectorF;
  AShift: TVectorF;
begin
  Result := False;
  if FIsTransition or FIsBack or FIsEnter then
    Exit;

  AWPosition := FCamera.GetWorldPos(AMousePosition);
  for ASystem in FSystems do
  begin
    if ChessDistation(ASystem.Sector, FCurrentSystem.Sector) > 1 then
      Continue;

    ASPosition := FCamera.GetScreenPos(ASystem.Position);
    if (ASPosition.X > -2 * SYSTEM_SIZE) and (ASPosition.Y > -2 * SYSTEM_SIZE) and
      (ASPosition.X < FCamera.Resolution.X + 2 * SYSTEM_SIZE) and
      (ASPosition.Y < FCamera.Resolution.Y + 2 * SYSTEM_SIZE)
    then
      if ASystem.IsContains(AWPosition) and CheckDistanceToCurrent(ASystem) then
      begin
        ASystem.FIsFocused := True;
        Break;
      end
      else
        ASystem.FIsFocused := False;
  end;

  if Assigned(FInfoSystem) and
    (Distance(AWPosition, FInfoSystem.Position) > SYSTEM_SIZE * 3)
  then
    FInfoSystem := nil;
end;

function TStarMap.OnMouseButtonUp(AButton: TMouseButton;
  const AMousePosition: TVectorF): Boolean;
var
  ASystem: TStarSystem;
  ASPosition, AWPosition: TVectorF;
  AShift: TVectorF;
begin
  Result := False;
  if FIsTransition or FIsBack or FIsEnter then
    Exit;

  AWPosition := FCamera.GetWorldPos(AMousePosition);
  if FCurrentSystem.IsContains(AWPosition) and (AButton = mbLeft) then
  begin
    FIsEnter := True;
    FTime := 0;
    Exit;
  end;

  for ASystem in FSystems do
  begin
    if ChessDistation(ASystem.Sector, FCurrentSystem.Sector) > 1 then
      Continue;
    ASPosition := FCamera.GetScreenPos(ASystem.Position);
    if (ASPosition.X > -2 * SYSTEM_SIZE) and (ASPosition.Y > -2 * SYSTEM_SIZE) and
      (ASPosition.X < FCamera.Resolution.X + 2 * SYSTEM_SIZE) and
      (ASPosition.Y < FCamera.Resolution.Y + 2 * SYSTEM_SIZE)
    then
      if ASystem.IsContains(AWPosition) and CheckDistanceToCurrent(ASystem) then
      begin
        if (AButton = mbLeft) and (ASystem <> FCurrentSystem) then
        begin
          if ASystem = FSelectedSystem then
          begin
            FIsTransition := True;
            FTime := 0;
          end
          else
          begin
            ASystem.FIsSelected := True;
            if Assigned(FSelectedSystem) then
              FSelectedSystem.FIsSelected := False;
            FSelectedSystem := ASystem;
          end;
          Break;
        end;

        if AButton = mbRight then
        begin
          FInfoSystem := ASystem;
          Break;
        end;
      end;
  end;
end;

function TStarMap.OnKeyUp(AKey: TKeyButton): Boolean;
begin
  Result := False;
  if FIsTransition or FIsBack or FIsEnter then
    Exit;

  if AKey = KB_ENTER then
  begin
    FIsEnter := True;
    FTime := 0;
  end;

  if AKey = KB_T then
  begin
    FIsTransition := True;
    FTime := 0;
  end;
end;
{$ENDREGION}

end.
