unit Project87.Types.GameObject;

interface

uses
  Generics.Collections,
  SysUtils,
  Strope.Math;

const
  MAX_PHYSICAL_VELOCITY = 1500;
  MAX_FAST_OBJECTS = 200;
  BORDER_OF_VIEW: TVector2F = (X: 800; Y: 600);

type
  TObjectManager = class;
  TPhysicalObject = class;

  TGameObject = class
    private
      FParent: TObjectManager;

      procedure Move(const ADelta: Double);
    protected
      FAngle: Single;
      FPreviosPosition: TVector2F;
      FPosition: TVector2F;
      FVelocity: TVector2F;
    public
      constructor Create;
      destructor Destroy; override;

      procedure OnDraw; virtual;
      procedure OnUpdate(const ADelta: Double); virtual;
      procedure OnCollide(OtherObject: TPhysicalObject); virtual;

      property Manager: TObjectManager read FParent;
      property Position: TVector2F read FPosition;
  end;

  TPhysicalObject = class
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
      constructor Create;
      destructor Destroy; override;

      procedure OnDraw; virtual;
      procedure OnUpdate(const ADelta: Double); virtual;
      procedure OnCollide(OtherObject: TPhysicalObject); virtual;

      property Manager: TObjectManager read FParent;
      property Position: TVector2F read FPosition;
  end;

  TObjectManager = class
    private
      class var FInstance: TObjectManager;

      FGameObject: TList<TGameObject>;
      FPhysicalObject: TList<TPhysicalObject>;

      constructor Create;

      procedure RemovePhysicalObject(APhysicalObject: TPhysicalObject);
      procedure DestroyPhysicalObject(APhysicalObject: TPhysicalObject);
      procedure AddPhysicalObject(APhysicalObject: TPhysicalObject);
      procedure RemoveObject(AObject: TGameObject);
      procedure DestroyObject(AObject: TGameObject);
      procedure AddObject(AObject: TGameObject);
      procedure CheckCollisions;
      procedure CheckFastCollisions;
    public
      destructor Destroy; override;

      class function GetInstance: TObjectManager;

      procedure OnDraw;
      procedure OnUpdate(const ADelta: Double);
  end;

implementation

uses
  QApplication.Application,
  QEngine.Core;

{$REGION '  TGameObject  '}
constructor TGameObject.Create;
begin
  FParent := TObjectManager.GetInstance;
  FParent.AddObject(Self);
end;

destructor TGameObject.Destroy;
begin
  FParent.RemoveObject(Self);
  inherited;
end;

procedure TGameObject.OnDraw;
begin
  //nothing to do
end;

procedure TGameObject.OnUpdate(const ADelta: Double);
begin
  //nothing to do
end;

procedure TGameObject.OnCollide(OtherObject: TPhysicalObject);
begin
  //nothing to do
end;

procedure TGameObject.Move(const ADelta: Double);
begin
  FPreviosPosition := FPosition;
  FPosition := FPosition + FVelocity * ADelta;
end;
{$ENDREGION}

{$REGION '  TPhysicalObject  '}
constructor TPhysicalObject.Create;
begin
  FUseCollistion := False;
  FParent := TObjectManager.GetInstance;
  FParent.AddPhysicalObject(Self);
  FMass := 1;
  FFriction := 2.5;
  FRadius := 20;
end;

destructor TPhysicalObject.Destroy;
begin
  FParent.RemovePhysicalObject(Self);

  inherited;
end;

procedure TPhysicalObject.OnDraw;
begin
  //nothing to do
end;

procedure TPhysicalObject.OnUpdate(const ADelta: Double);
begin
  //nothing to do
end;

procedure TPhysicalObject.OnCollide(OtherObject: TPhysicalObject);
begin
  //nothing to do
end;

procedure TPhysicalObject.Move(const ADelta: Double);
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
  FPhysicalObject := TList<TPhysicalObject>.Create();
  FGameObject := TList<TGameObject>.Create();
end;

destructor TObjectManager.Destroy;
var
  AGameObject: TGameObject;
  APhysicalObject: TPhysicalObject;
begin
  for APhysicalObject in FPhysicalObject do
    APhysicalObject.Free;
  FPhysicalObject.Free;

  for AGameObject in FGameObject do
    AGameObject.Free;
  FGameObject.Free;

  FInstance := nil;

  inherited;
end;

procedure TObjectManager.RemovePhysicalObject(APhysicalObject: TPhysicalObject);
begin
  FPhysicalObject.Remove(APhysicalObject);
end;

procedure TObjectManager.DestroyPhysicalObject(APhysicalObject: TPhysicalObject);
begin
  if FPhysicalObject.Contains(APhysicalObject) then
    APhysicalObject.Free;
end;

procedure TObjectManager.AddPhysicalObject(APhysicalObject: TPhysicalObject);
begin
  if Assigned(APhysicalObject) then
    FPhysicalObject.Add(APhysicalObject);
end;

procedure TObjectManager.RemoveObject(AObject: TGameObject);
begin
  FGameObject.Remove(AObject);
end;

procedure TObjectManager.DestroyObject(AObject: TGameObject);
begin
  if FGameObject.Contains(AObject) then
    AObject.Free;
end;

procedure TObjectManager.AddObject(AObject: TGameObject);
begin
  if Assigned(AObject) then
    FGameObject.Add(AObject);
end;

class function TObjectManager.GetInstance: TObjectManager;
begin
  if not Assigned(FInstance) then
    FInstance := TObjectManager.Create;

  Result := FInstance;
end;

procedure TObjectManager.OnDraw;
var
  PhysicalObject: TPhysicalObject;
  GameObject: TGameObject;
begin
  for PhysicalObject in FPhysicalObject do
    PhysicalObject.OnDraw;
  for GameObject in FGameObject do
    GameObject.OnDraw;
end;

procedure TObjectManager.OnUpdate(const ADelta: Double);
var
  PhysicalObject: TPhysicalObject;
  GameObject: TGameObject;
begin
  for PhysicalObject in FPhysicalObject do
    PhysicalObject.OnUpdate(ADelta);

  CheckCollisions();

  for PhysicalObject in FPhysicalObject do
    PhysicalObject.Move(ADelta);

  for GameObject in FGameObject do
    GameObject.OnUpdate(ADelta);

  CheckFastCollisions();

  for GameObject in FGameObject do
    GameObject.Move(ADelta);
end;

procedure TObjectManager.CheckCollisions;
var
  GameObject, OtherObject: TPhysicalObject;
  Connection: TVector2F;
  ProjectionLength: Single;
begin
  for GameObject in FPhysicalObject do
    for OtherObject in FPhysicalObject do
      if (GameObject <> OtherObject) then
        if (Distance(GameObject.FPosition, OtherObject.FPosition) <
          GameObject.FRadius + OtherObject.FRadius)
        then
        begin
          GameObject.OnCollide(OtherObject);

          if GameObject.FUseCollistion and OtherObject.FUseCollistion then
          begin
            Connection := OtherObject.FPosition - GameObject.FPosition;

            ProjectionLength := Dot(OtherObject.FVelocity, Connection) / Connection.Length;

            GameObject.FVelocity := GameObject.FVelocity -
              GetRotatedVector(
                GetAngle(Connection),
                ProjectionLength / GameObject.FMass * OtherObject.FMass);

            OtherObject.FVelocity := OtherObject.FVelocity +
              GetRotatedVector(GetAngle(Connection), ProjectionLength);

            GameObject.FCorrection :=
              (GameObject.FPosition - OtherObject.FPosition).Normalize *
              (((GameObject.FRadius + OtherObject.FRadius) -
                Distance(GameObject.FPosition, OtherObject.FPosition)) * 0.5);
          end;
        end;
end;

procedure TObjectManager.CheckFastCollisions;
var
  I,
  FastListCount: Integer;
  PhysicalObject: TPhysicalObject;
  GameObject: TGameObject;
  FastList: array [0..MAX_FAST_OBJECTS] of TPhysicalObject;
  ActionCenter: TVector2F;
begin
  FastListCount := 0;
  ActionCenter := TheEngine.Camera.Position;
  for PhysicalObject in FPhysicalObject do
    if (PhysicalObject <> nil) then
    if (PhysicalObject.FPosition.X - BORDER_OF_VIEW.X < ActionCenter.X) then
    if (PhysicalObject.FPosition.Y - BORDER_OF_VIEW.Y < ActionCenter.Y) then
    if (PhysicalObject.FPosition.X + BORDER_OF_VIEW.X > ActionCenter.X) then
    if (PhysicalObject.FPosition.Y + BORDER_OF_VIEW.Y > ActionCenter.Y) then
      begin
        if FastListCount > MAX_FAST_OBJECTS then
          Break;
        FastList[FastListCount] := PhysicalObject;
        Inc(FastListCount);
      end;
//  TheApplication.Window.Caption := IntToStr(FastListCount);
  for GameObject in FGameObject do
    if (GameObject <> nil) then
      for i := 0 to FastListCount - 1 do
        if LineVsCircle(GameObject.FPosition, GameObject.FPreviosPosition, FastList[I].FPosition, FastList[I].FRadius) then
          GameObject.OnCollide(FastList[I]);
end;

{$ENDREGION}

end.
