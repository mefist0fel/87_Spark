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
  TLiveFraction = (lfRed = 0, lfBlue = 1, lfGreen = 2);

  TStarSystem = class sealed
    strict private
      FId: TObjectId;
      FSector: TVectorI;

      FIsOpened: Boolean;
      FPosition: TVectorF;

      FSize: TSystemSize;
      FType: TSystemType;
      FConfiguration: TSystemConfiguration;
      FFractions: set of TLiveFraction;
      FSeed: Cardinal;
      FLifeSeed: Cardinal;
    private
      FIsSelected: Boolean;
      FIsFocused: Boolean;

      procedure Generate(const AScetor: TVector2I);
      procedure LoadFromStream(AStrem: TFileStream);
      procedure SaveToStream(AStream: TFileStream);

      function IsContains(const APoint: TVectorF): Boolean;
    public
      constructor Create;

      property Id: TObjectId read FId;
      property Sector: TVectorI read FSector;
      property Position: TVectorF read FPosition;

      property Size: TSystemSize read FSize;
      property SystemType: TSystemType read FType;
      property Configuration: TSystemConfiguration read FConfiguration;
      property Fractions: set of TLiveFraction read FFractions;
      property Seed: Cardinal read FSeed;
      property LifeSeed: Cardinal: read FSeed;
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

{$REGION '  TStarSystem  '}
constructor TStarSystem.Create;
begin
  FId := 0;
end;

procedure TStarSystem.Generate;
begin

end;

procedure TStarSystem.LoadFromStream(AStrem: TFileStream);
begin

end;

procedure TStarSystem.SaveToStream(AStream: TFileStream);
begin

end;

function TStarSystem.IsContains(const APoint: TVector2F)
begin

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
