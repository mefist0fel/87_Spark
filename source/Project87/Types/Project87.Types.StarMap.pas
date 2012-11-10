unit Project87.Types.StarMap;

interface

uses
  Classes,
  Generics.Collections,
  QCore.Types,
  QCore.Input,
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
    private
      class procedure TakeId(Id: TObjectId);
      class function GetNewId(): TObjectId;
    public
      class constructor CreateClass;

      constructor Create;
      destructor Destroy; override;

      procedure LoadFromFile(const AFile: string);

      procedure OnInitialize(AParameter: TObject = nil); override;
      procedure OnDraw(const ALayer: Integer); override;
      procedure OnUpdate(const ADelta: Double); override;

      function OnMouseMove(const AMousePosition: TVectorF): Boolean; override;
      function OnMouseButtonUp(AButton: TMouseButton;
        const AMousePosition: TVectorF): Boolean; override;
      function OnKeyUp(AKey: TKeyButton): Boolean; override;
  end;

implementation

const
  SECTOR_SIZE = 5000;
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
  FSystems := TList<TStarSystem>.Create;
  FCurrentSystem := nil;
  FSelectedSystem := nil;
end;

destructor TStarMap.Destroy;
var
  ASystem: TStarSystem;
begin
  for ASystem in FSystems do
    ASystem.Free;
  FSystems.Free;

  inherited;
end;

procedure TStarMap.LoadFromFile(const AFile: string);
begin

end;

procedure TStarMap.OnInitialize(AParameter: TObject);
begin

end;

procedure TStarMap.OnDraw(const ALayer: Integer);
begin

end;

procedure TStarMap.OnUpdate(const ADelta: Double);
begin

end;

function TStarMap.OnMouseMove(const AMousePosition: TVectorF): Boolean;
begin

end;

function TStarMap.OnMouseButtonUp(AButton: TMouseButton;
  const AMousePosition: TVectorF): Boolean;
begin

end;

function TStarMap.OnKeyUp(AKey: TKeyButton): Boolean;
begin

end;
{$ENDREGION}

end.
