unit Project87.Types.GameObject;

interface

uses
  Generics.Collections,
  SysUtils,
  Strope.Math;

const
  MAX_PHYSICAL_VELOCITY = 1500;

type
  TObjectManager = class;

  TGameObject = class
  private
    FFriction: Single;
    FCorrection: TVector2F;
    FParent: TObjectManager;
    procedure Move(const ADelta: Double);
  protected
    FUseCollistion: Boolean;
    FMass: Single;
    FRadius: Single;
    FAngle: Single;
    FPosition: TVector2F;
    FVelocity: TVector2F;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure OnDraw; virtual;
    procedure OnUpdate(const ADelta: Double); virtual;
    procedure OnCollide(OtherObject: TGameObject); virtual;
    property Manager: TObjectManager read FParent;
    property Position: TVector2F read FPosition;
  end;

  TObjectManager = class
  private
    class var FInstance: TObjectManager;
    FObject: TList<TGameObject>;
    constructor Create;

    procedure DestroyObject(AObject: TGameObject);
    procedure AddObject(AObject: TGameObject);
    procedure CheckCollisions;
  public
    destructor Destroy; override;

    class function GetInstance: TObjectManager;

    procedure OnDraw;
    procedure OnUpdate(const ADelta: Double);
  end;

implementation

{$REGION '  TGameObject  '}
constructor TGameObject.Create;
begin
  FUseCollistion := False;
  FParent := TObjectManager.GetInstance;
  FParent.AddObject(Self);
  FMass := 1;
  FFriction := 2.5;
  FRadius := 20;
  inherited;
end;

destructor TGameObject.Destroy;
begin
  FParent.DestroyObject(Self);
  inherited;
end;

procedure TGameObject.OnDraw;
begin

end;

procedure TGameObject.OnUpdate(const ADelta: Double);
begin

end;

procedure TGameObject.OnCollide(OtherObject: TGameObject);
begin

end;

procedure TGameObject.Move(const ADelta: Double);
begin
  if FVelocity.Length > MAX_PHYSICAL_VELOCITY then
    FVelocity := FVelocity * (MAX_PHYSICAL_VELOCITY / FVelocity.Length);
  FPosition := FPosition + FVelocity * ADelta + FCorrection;
  FCorrection := ZeroVectorF;
  FVelocity := FVelocity * (1 - ADelta * FFriction);
end;
{$ENDREGION}

{$REGION '  TObjectManager  '}
constructor TObjectManager.Create;
begin
  FObject := TList<TGameObject>.Create();
  inherited;
end;

destructor TObjectManager.Destroy;
begin
  FObject.Destroy;
  inherited;
end;

procedure TObjectManager.DestroyObject(AObject: TGameObject);
begin
  if FObject.Contains(AObject) then
  begin
    FObject.Remove(AObject);
    FreeAndNil(AObject);
  end;
end;

procedure TObjectManager.AddObject(AObject: TGameObject);
begin
  FObject.Add(AObject);
end;

class function TObjectManager.GetInstance: TObjectManager;
begin
  if FInstance = nil then
    FInstance := TObjectManager.Create;
  Result := FInstance;
end;

procedure TObjectManager.CheckCollisions;
var
  GameObject,
  OtherObject: TGameObject;
  Connection: TVector2F;
  ProjectionLength: Single;
begin
  for GameObject in FObject do
    for OtherObject in FObject do
      if (GameObject <> OtherObject) then
        if (Distance(GameObject.FPosition, OtherObject.FPosition) < GameObject.FRadius + OtherObject.FRadius) then
        begin
          GameObject.OnCollide(OtherObject);
          if GameObject.FUseCollistion and OtherObject.FUseCollistion then
          begin
            Connection := OtherObject.FPosition - GameObject.FPosition;
            ProjectionLength := Dot(OtherObject.FVelocity, Connection) / Connection.Length;
            GameObject.FVelocity := GameObject.FVelocity - ClipAndRotate(GetAngle(Connection), ProjectionLength / GameObject.FMass * OtherObject.FMass);
            OtherObject.FVelocity := OtherObject.FVelocity + ClipAndRotate(GetAngle(Connection), ProjectionLength);
            GameObject.FCorrection :=
              (GameObject.FPosition - OtherObject.FPosition).Normalize *
              (((GameObject.FRadius + OtherObject.FRadius) - Distance(GameObject.FPosition, OtherObject.FPosition)) * 0.5);
          end;
        end;
end;

procedure TObjectManager.OnUpdate(const ADelta: Double);
var
  GameObject: TGameObject;
begin
  for GameObject in FObject do
    GameObject.OnUpdate(ADelta);
  CheckCollisions();
  for GameObject in FObject do
    GameObject.Move(ADelta);
end;

procedure TObjectManager.OnDraw;
var
  GameObject: TGameObject;
begin
  for GameObject in FObject do
    GameObject.OnDraw;
end;
{$ENDREGION}

end.
