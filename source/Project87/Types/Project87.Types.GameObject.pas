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














    procedure OnDraw; virtual;
    procedure OnUpdate(const ADelta: Double); virtual;

    property Manager: TObjectManager read FParent;
  end;

  TObjectManager = class
  private
    class var FInstance: TObjectManager;
    FObject: TList<TGameObject>;

    constructor Create;
    destructor Destroy;

    procedure DestroyObject(AObject: TGameObject);
    procedure AddObject(AObject: TGameObject);
    procedure CheckCollisions;
  public
    class function GetInstance: TObjectManager;

    procedure OnDraw;
    procedure OnUpdate(const ADelta: Double);
  end;

implementation

{$REGION '  TGameObject  '}
constructor TGameObject.Create;
begin
  FParent := TObjectManager.GetInstance;
  FParent.AddObject(Self);
  FMass := 1;
  FFriction := 2.5;
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

procedure TGameObject.Move(const ADelta: Double);
begin
  if FVelocity.Length > MAX_PHYSICAL_VELOCITY then
    FVelocity := FVelocity * (MAX_PHYSICAL_VELOCITY / FVelocity.Length);
  FPosition := FPosition + FVelocity * ADelta;
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
begin
  for GameObject in FObject do
    for OtherObject in FObject do
      if (GameObject <> OtherObject) then
        if (Distance(GameObject.FPosition, OtherObject.FPosition) < GameObject.FRadius + OtherObject.FRadius) then
        begin
          Connection := GameObject.FPosition - OtherObject.FPosition;
          GameObject.FCorrection := Connection;

        end;
end;

procedure TObjectManager.OnUpdate(const ADelta: Double);
var
  GameObject: TGameObject;
begin
  for GameObject in FObject do
    GameObject.OnUpdate(ADelta);
  for GameObject in FObject do
    GameObject.Move(ADelta);
  CheckCollisions();
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
