unit Project87.Hero;

interface

uses
  QEngine.Camera,
  QGame.Scene,
  Strope.Math,
  Project87.Fluid,
  Project87.BaseUnit,
  Project87.Types.GameObject,
  Project87.Types.StarMap,
  Project87.Types.Weapon;

const
  IN_SYSTEM_JUMP_SPEED = 500;
  RADAR_DISTANCE = 1500;

type
//Hero parameters
  THero = class
    private class var FInstance: THero;
    private
      FLevel: Word;//:)
      FFluid: TResources;

      function GetFluid(AIndex: Integer): Word;
      constructor Create;
    public

      class function GetInstance: THero;
      procedure AddFluid(AType: TFluidType);
      property Fluid[AIndex: Integer]: Word read GetFluid;
  end;
//Hero starship and all it physical parameters
  THeroShip = class (TBaseUnit)
    private
      FNeedAngle: Single;
      FAngularSpeed: Single;
      FNeedCameraPosition: TVector2F;
      FHeroMaxSpeed: Single;
      FNeedSpeed: Single;
      FSpeed: Single;
      FCannon: TCannon;
      FScanner: TScanner;

      FOldPosition: TVectorF;

      procedure Control(const  ADelta: Double);
      procedure UpdateParameters(const ADelta: Double);
      procedure CheckKeys;
      procedure CheckMouse;
    public
      constructor CreateUnit(const APosition: TVector2F; AAngle: Single; ASide: TUnitSide); override;

      procedure OnDraw; override;
      procedure OnUpdate(const  ADelta: Double); override;
      procedure OnCollide(OtherObject: TPhysicalObject); override;

      procedure FlyInSystem(APosition: TVector2F; AAngle: Single);
  end;

implementation

uses
  QuadEngine,
  SysUtils,
  QEngine.Core,
  QCore.Input,
  QApplication.Application,
  Project87.Asteroid,
  Project87.BaseEnemy,
  Project87.Resources,
  Project87.Types.StarFon;

{$REGION '  THero  '}
constructor THero.Create;
begin

end;

class function THero.GetInstance: THero;
begin
  if FInstance = nil then
    FInstance := THero.Create;
  Result := FInstance;
end;

function THero.GetFluid(AIndex: Integer): Word;
begin
  if (AIndex < 0) or (AIndex >= FLUID_TYPE_COUNT) then
    Exit(0);
  Result := FFluid[AIndex];
end;

procedure THero.AddFluid(AType: TFluidType);
begin
  Inc(FFluid[(Word(AType))]);
end;
{$ENDREGION}

{$REGION '  THero Ship  '}
constructor THeroShip.CreateUnit(const APosition: TVector2F; AAngle: Single; ASide: TUnitSide);
begin
  inherited;
  FCannon := TCannon.Create(OPlayer, 0.1, 20);
  FScanner := TScanner.Create;
  FAngularSpeed := 20;
  FRadius := 35;
  FHeroMaxSpeed := 40;
  FUseCollistion := True;
  FMass := 1;
  FOldPosition := FPosition;
end;

procedure THeroShip.OnDraw;
var
  ShieldAlpha: Byte;
begin
  TheResources.HeroTexture.Draw(FPosition, Vec2F(30, 50), FAngle, $FFFFFFFF);
  TheResources.HeroTexture.Draw(FPosition, Vec2F(10, 20), FTowerAngle, $FFFFFFFF);
  ShieldAlpha := Trunc(FShowShieldTime * $52);
  TheResources.AsteroidTexture.Draw(FPosition, Vec2F(70, 70), FTowerAngle, ShieldAlpha * $1000000 + $FFFFFF);
end;

procedure THeroShip.OnUpdate(const ADelta: Double);
var
  AShift: TVectorF;
begin
  inherited;
  CheckKeys;
  CheckMouse;
  UpdateParameters(ADelta);
  Control(ADelta);
  FCannon.OnUpdate(ADelta);
  FScanner.OnUpdate(ADelta);

  AShift := FOldPosition - Position;
  FOldPosition := Position;
  AShift := AShift * 0.06;
  TStarFon.Instance.Shift(AShift);
end;

procedure THeroShip.Control(const ADelta: Double);
var
  MousePosition: TVector2F;
  DistanceToCamera: Single;
begin
  MousePosition := TheEngine.Camera.GetWorldPos(TheControlState.Mouse.Position);
  FTowerAngle := GetAngle(FPosition, MousePosition);
  DistanceToCamera := ((MousePosition - FPosition).Length) / 200;
  if DistanceToCamera < 1 then
    DistanceToCamera := 1;

  FNeedCameraPosition := {(MousePosition - FPosition) * (0.5 / DistanceToCamera) + }FPosition;
  TheEngine.Camera.Position := TheEngine.Camera.Position * (1 - ADelta * 20) +
    FNeedCameraPosition * (ADelta * 20);
end;

procedure THeroShip.OnCollide(OtherObject: TPhysicalObject);
begin
  if (OtherObject is TAsteroid) then
  begin
    FShowShieldTime := 0.7;
  end;
  if (OtherObject is TBaseEnemy) then
  begin
    FShowShieldTime := 0.7;
  end;
end;

procedure THeroShip.FlyInSystem(APosition: TVector2F; AAngle: Single);
begin
  FPosition := APosition;
  FAngle := AAngle;
  FVelocity := GetRotatedVector(FAngle, IN_SYSTEM_JUMP_SPEED);
end;

procedure THeroShip.UpdateParameters(const ADelta: Double);
begin
  FAngle := RotateToAngle(FAngle, FNeedAngle, 220 * ADelta);
  FSpeed := FSpeed * (1 - ADelta * 50) + FNeedSpeed * (ADelta * 50);
  FVelocity := FVelocity + GetRotatedVector(FAngle, FSpeed);
  if FVelocity.Length > 600 then
    FVelocity := FVelocity * (600 / FVelocity.Length);
end;

procedure THeroShip.CheckMouse;
begin
  if TheMouseState.IsButtonPressed[mbLeft] then
    FCannon.Fire(FPosition, FTowerAngle);
  if TheMouseState.IsButtonPressed[mbMiddle] then
    FScanner.Fire(FPosition, FTowerAngle);
end;

procedure THeroShip.CheckKeys;
var
  NeedDirection: TVector2F;
begin
  NeedDirection := ZeroVectorF;
  FNeedSpeed := 0;

 { if TheControlState.Keyboard.IsKeyPressed[KB_W] or
     TheControlState.Keyboard.IsKeyPressed[KB_UP] then
    NeedDirection := NeedDirection + TVector2F.Create(0, 1);
  if TheControlState.Keyboard.IsKeyPressed[KB_S] or
     TheControlState.Keyboard.IsKeyPressed[KB_DOWN] then
    NeedDirection := NeedDirection + TVector2F.Create(0,-1);
  if TheControlState.Keyboard.IsKeyPressed[KB_A] or
     TheControlState.Keyboard.IsKeyPressed[KB_LEFT] then
    NeedDirection := NeedDirection + TVector2F.Create(1, 0);
  if TheControlState.Keyboard.IsKeyPressed[KB_D] or
     TheControlState.Keyboard.IsKeyPressed[KB_RIGHT] then
    NeedDirection := NeedDirection + TVector2F.Create(-1, 0);
  if NeedDirection = ZeroVectorF then
  begin
    FMoveDirection := ZeroVectorF;
    FNeedAngle := FAngle;
  end
  else
  begin
    FMoveDirection := NeedDirection.Normalized;
    FNeedAngle := GetAngle(FMoveDirection);
    FNeedSpeed := FHeroMaxSpeed;
  end;          }

  FNeedAngle := FAngle;
//  FAngularSpeed := FAngularSpeed * 0.9;
  if TheKeyboardState.IsKeyPressed[KB_A] or
     TheKeyboardState.IsKeyPressed[KB_LEFT]
  then
  begin
//    FAngularSpeed := FAngularSpeed - 0.5;
//    if FAngularSpeed < -20 then
//      FAngularSpeed := -20;
    FNeedAngle := RoundAngle(FNeedAngle - FAngularSpeed);
  end;

  if TheKeyboardState.IsKeyPressed[KB_D] or
     TheKeyboardState.IsKeyPressed[KB_RIGHT]
  then
  begin
//    FAngularSpeed := FAngularSpeed + 0.5;
//    if FAngularSpeed > 20 then
//      FAngularSpeed := 20;
    FNeedAngle := RoundAngle(FNeedAngle + FAngularSpeed);
  end;

  if TheKeyboardState.IsKeyPressed[KB_W] or
     TheKeyboardState.IsKeyPressed[KB_UP]
  then
    FNeedSpeed := FHeroMaxSpeed;
end;
{$ENDREGION}

end.
