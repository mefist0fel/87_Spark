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
  Strope.Math;

type
  TSystemSize = (ssSmall = 0, ssMedium = 1, ssBig = 2);
  TSystemType = (stIce = 0, stStone = 1, stLife = 2);
  TSystemConfiguration = (scDischarged = 0, scCompact = 1, scPlanet = 2);
  TLifeFraction = (lfRed = 0, lfBlue = 1, lfGreen = 2);

  TLifeFractions = set of TLifeFraction;

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
      FEnemies: Single;
      FResources: Single;
    private
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

      FStarMarker: TQuadTexture;
      FCamera: IQuadCamera;

      function ChessDistation(const A, B: TVectorI): Integer;
      function IsHaveAllNeighbors(const ASector: TVectorI): Boolean;
      procedure GenerateSystems(const ASector: TVectorI);
      procedure GenerateMissingSectors(const ASector: TVectorI);

      procedure DrawSystemMarker(ASystem: TStarSystem);
    private
      class procedure TakeId(Id: TObjectId);
      class function GetNewId(): TObjectId;
    public
      class constructor CreateClass;

      constructor Create;
      destructor Destroy; override;

      procedure FillFirst;
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
  QGame.Game,
  QGame.Resources;

const
  SECTOR_SIZE = 2048;
  SYSTEMS_IN_SECTOR = 100;
  SYSTEM_SIZE = 15;

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
  //0 - ������ nil
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

  FStarMarker :=
    (TheResourceManager.GetResource('Image', 'SimpleStarMarker') as TTextureExResource).Texture;

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
  Result := Min(Abs(A.X - B.X), Abs(A.Y - B.Y));
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

procedure TStarMap.DrawSystemMarker(ASystem: TStarSystem);
var
  ASize: Single;
  AColor: Cardinal;
begin
  ASize := 1;
  AColor := $FFFFFFFF;

  if ASystem = FCurrentSystem then
  begin
    ASize := 1.2;
    AColor := $FFFF8080;
  end;

  if ASystem = FSelectedSystem then
  begin
    ASize := 1.2;
    AColor := $FFFFB080;
  end;

  if ASystem.FIsFocused then
  begin
    ASize := 1.2;
  end;

  FStarMarker.Draw(ASystem.Position, Vec2F(20, 20) * ASize,
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
  //nothing to do
end;

procedure TStarMap.OnDraw(const ALayer: Integer);
var
  ASystem: TStarSystem;
  ASPosition: TVectorF;
  AShift: TVectorF;
begin
  TheEngine.Camera := FCamera;
  FCamera.Position := FCurrentSystem.Position;
  for ASystem in FSystems do
  begin
    ASPosition := FCamera.GetScreenPos(ASystem.Position);
    if (ASPosition.X > -2 * SYSTEM_SIZE) and (ASPosition.Y > -2 * SYSTEM_SIZE) and
      (ASPosition.X < FCamera.Resolution.X + 2 * SYSTEM_SIZE) and
      (ASPosition.Y < FCamera.Resolution.Y + 2 * SYSTEM_SIZE)
    then
    begin
      DrawSystemMarker(ASystem);
    end;
  end;
end;

procedure TStarMap.OnUpdate(const ADelta: Double);
begin
end;

function TStarMap.OnMouseMove(const AMousePosition: TVectorF): Boolean;
var
  ASystem: TStarSystem;
  ASPosition, AWPosition: TVectorF;
  AShift: TVectorF;
begin
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
      if ASystem.IsContains(AWPosition) then
      begin
        ASystem.FIsFocused := True;
        Break;
      end
      else
        ASystem.FIsFocused := False;
  end;
end;

function TStarMap.OnMouseButtonUp(AButton: TMouseButton;
  const AMousePosition: TVectorF): Boolean;
var
  ASystem: TStarSystem;
  ASPosition, AWPosition: TVectorF;
  AShift: TVectorF;
begin
  AWPosition := FCamera.GetWorldPos(AMousePosition);
  for ASystem in FSystems do
  begin
    if ChessDistation(ASystem.Sector, FCurrentSystem.Sector) > 1 then
      Continue;
    if ASystem = FCurrentSystem then
      Continue;

    ASPosition := FCamera.GetScreenPos(ASystem.Position);
    if (ASPosition.X > -2 * SYSTEM_SIZE) and (ASPosition.Y > -2 * SYSTEM_SIZE) and
      (ASPosition.X < FCamera.Resolution.X + 2 * SYSTEM_SIZE) and
      (ASPosition.Y < FCamera.Resolution.Y + 2 * SYSTEM_SIZE)
    then
      if ASystem.IsContains(AWPosition) then
      begin
        ASystem.FIsSelected := True;
        if Assigned(FSelectedSystem) then
          FSelectedSystem.FIsSelected := False;
        FSelectedSystem := ASystem;
        Break;
      end;
  end;
end;

function TStarMap.OnKeyUp(AKey: TKeyButton): Boolean;
begin

end;
{$ENDREGION}

end.
