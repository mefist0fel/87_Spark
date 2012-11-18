unit Project87.Hero;

interface

uses
  QEngine.Camera,
  QGame.Scene,
  Strope.Math,
  Project87.Fluid,
  Project87.BaseUnit,
  Project87.Types.Weapon,
  Project87.Types.GameObject,
  Project87.Types.StarMap;

const
  IN_SYSTEM_JUMP_SPEED = 500;
  DEFAULT_LIFE = 100;
  RADAR_DISTANCE = 1500;
  BASE_ENERGY_RECOVERY_IN_SECOND = 0.002;
  BASE_ENERGY_CONSUMPTION = 0.2;
  BASE_NEED_EXP = 500;
  BASE_LIFE = 100;
  LEVELUP_VALUE = 1.1;
  NEEDEXP_FACTOR = 2;
  LIFE_ADDITION = 4;

type
  //Hero parameters
  THero = class
    private
      class var FInstance: THero;
    private
      FIsDead: Boolean;
      FExp, FNeedExp: Integer;
      FExpFactor: Single;
      FLife, FMaxLife: Single;
      FEnergy: Single;
      FLevel: Word;//:)
      FFluid: TResources;
      FRocketCount, FMaxRocketCount: Word;

      FIsUsePower: Boolean;
      FUseDuration, FTime: Single;
      FTransPower, FStartPower, FNeedPower: Single;
      FTransPowerRecoveryFactor: Single;
      FTransPowerConsumptionFactor: Single;

      constructor Create;

      function GetFluid(AIndex: Integer): Word;
      function GetTransRecovery(): Single;
      function GetTransConsumption(): Single;
    public
      class function GetInstance: THero;

      procedure NewPlayer;
      procedure RebornPlayer;
      procedure KillPlayer;
      procedure LoadFromFile(const AFile: string);
      procedure SaveToFile(const AFile: string);

      procedure AddFluid(AType: TFluidType);
      procedure AddExp(ACount: Integer);
      procedure UpdateTransPower(ADelta: Double);
      procedure UseTransPower(ADuration: Double);

      property IsDead: Boolean read FIsDead;
      property ExpFactor: Single read FExpFactor;
      property Experience: Integer read FExp;
      property NeedExperience: Integer read FNeedExp;
      property Fluid[AIndex: Integer]: Word read GetFluid;
      property Rockets: Word read FRocketCount write FRocketCount;
      property Life: Single read FLife;
      property MaxLife: Single read FMaxLife;
      property Energy: Single read FEnergy;
      property TransPower: Single read FTransPower;
      property TransPowerRecovery: Single read GetTransRecovery;
      property TransPowerConsumption: Single read GetTransConsumption;
  end;

  //Hero starship and all it physical parameters
  THeroShip = class (TBaseUnit)
    private
      class var FInstance: THeroShip;
    private
      FNeedAngle: Single;
      FAngularSpeed: Single;
      FNeedCameraPosition: TVector2F;
      FHeroMaxSpeed: Single;
      FNeedSpeed: Single;
      FSpeed: Single;
      FCannon: TCannon;
      FLauncher: TLauncher;
      FScanner: TScanner;

      FOldPosition: TVectorF;

      procedure Control(const  ADelta: Double);
      procedure UpdateParameters(const ADelta: Double);
      procedure CheckKeys;
      procedure CheckMouse;
    public
      constructor CreateUnit(const APosition: TVector2F; AAngle: Single; ASide: TLifeFraction); override;
      destructor Destroy;

      class function GetInstance: THeroShip;
      procedure OnDraw; override;
      procedure OnUpdate(const  ADelta: Double); override;
      procedure OnCollide(AObject: TPhysicalObject); override;
      procedure Hit(ADamage: Single); override;
      procedure FlyInSystem(APosition: TVector2F; AAngle: Single);
  end;

implementation

uses
  Math,
  Classes,
  QuadEngine,
  SysUtils,
  QEngine.Core,
  QCore.Input,
  QApplication.Application,
  Project87.Asteroid,
  Project87.BaseEnemy,
  Project87.Resources,
  Project87.Rocket,
  Project87.Types.StarFon;

{$REGION '  THero  '}
constructor THero.Create;
begin
  NewPlayer;
end;

class function THero.GetInstance: THero;
begin
  if FInstance = nil then
    FInstance := THero.Create;
  Result := FInstance;
end;

procedure THero.NewPlayer;
begin
  FExp := 0;
  FLevel := 1;
  FNeedExp := 100;
  FLife := DEFAULT_LIFE;
  FMaxLife := DEFAULT_LIFE;
  FEnergy := 1;
  FMaxRocketCount := 5;
  FRocketCount := 30;

  FTransPower := 1;
  FTransPowerRecoveryFactor := 1;
  FTransPowerConsumptionFactor := 1;
  FIsUsePower := False;
end;

procedure THero.RebornPlayer;
begin
  FIsDead := False;
end;

procedure THero.KillPlayer;
begin
  FIsDead := True;
  FTransPower := 0.5;
  FExp := 0;
  FNeedExp := BASE_NEED_EXP;
  FLife := BASE_LIFE;
  FMaxLife := BASE_LIFE;
end;

procedure THero.AddExp(ACount: Integer);
begin
  FExp := FExp + ACount;
  if FExp > FNeedExp then
  begin
    Inc(FLevel);
    FExpFactor := Power(LEVELUP_VALUE, FLevel);
    FMaxLife := BASE_NEED_EXP * FExpFactor;
    FNeedExp := Trunc(FNeedExp + FNeedExp * NEEDEXP_FACTOR);
  end;
end;

procedure THero.LoadFromFile(const AFile: string);
var
  AStream: TFileStream;
  I: Integer;
begin
  AStream := TFileStream.Create(AFile, fmOpenRead);
    AStream.Read(FExp, SizeOf(FExp));
    AStream.Read(FNeedExp, SizeOf(FNeedExp));
    AStream.Read(FLife, SizeOf(FLife));
    AStream.Read(FEnergy, SizeOf(FEnergy));
    AStream.Read(FLevel, SizeOf(FLevel));
    FExpFactor := Power(LEVELUP_VALUE, FLevel);

    for I := 0 to FLUID_TYPE_COUNT - 1 do
      AStream.Read(FFluid[I], SizeOf(FFluid[I]));

    AStream.Read(FRocketCount, SizeOf(FRocketCount));
    AStream.Read(FMaxRocketCount, SizeOf(FRocketCount));
    AStream.Read(FTransPower, SizeOf(FTransPower));
    AStream.Read(FTransPowerRecoveryFactor, SizeOf(FTransPowerRecoveryFactor));
    AStream.Read(FTransPowerConsumptionFactor, SizeOf(FTransPowerConsumptionFactor));
  AStream.Free;
end;

procedure THero.SaveToFile(const AFile: string);
var
  AStream: TFileStream;
  I: Integer;
begin
  AStream := TFileStream.Create(AFile, fmOpenWrite);
    AStream.Write(FExp, SizeOf(FExp));
    AStream.Write(FNeedExp, SizeOf(FNeedExp));
    AStream.Write(FLife, SizeOf(FLife));
    AStream.Write(FEnergy, SizeOf(FEnergy));
    AStream.Write(FLevel, SizeOf(FLevel));

    for I := 0 to FLUID_TYPE_COUNT - 1 do
      AStream.Write(FFluid[I], SizeOf(FFluid[I]));

    AStream.Write(FRocketCount, SizeOf(FRocketCount));
    AStream.Write(FMaxRocketCount, SizeOf(FRocketCount));
    AStream.Write(FTransPower, SizeOf(FTransPower));
    AStream.Write(FTransPowerRecoveryFactor, SizeOf(FTransPowerRecoveryFactor));
    AStream.Write(FTransPowerConsumptionFactor, SizeOf(FTransPowerConsumptionFactor));
  AStream.Free;
end;

function THero.GetFluid(AIndex: Integer): Word;
begin
  if (AIndex < 0) or (AIndex >= FLUID_TYPE_COUNT) then
    Exit(0);
  Result := FFluid[AIndex];
end;

function THero.GetTransRecovery;
begin
  Result := BASE_ENERGY_RECOVERY_IN_SECOND * FTransPowerRecoveryFactor * FExpFactor;
end;

function THero.GetTransConsumption;
begin
  Result := BASE_ENERGY_CONSUMPTION / (FTransPowerConsumptionFactor);
end;

procedure THero.AddFluid(AType: TFluidType);
begin
  Inc(FFluid[(Word(AType))]);
end;

procedure THero.UpdateTransPower(ADelta: Double);
begin
  if FIsUsePower then
  begin
    FTime := FTime + ADelta;
    FTransPower := InterpolateValue(FStartPower, FNeedPower, FTime / FUseDuration, itHermit01);
    FTransPower := Clamp(FTransPower, 1, 0);
    if FTime > FUseDuration then
    begin
      FTransPower := FNeedPower;
      FIsUsePower := False;
    end;
  end
  else
  begin
    FTransPower := FTransPower + TransPowerRecovery * ADelta;
    FTransPower := Clamp(FTransPower, 1, 0);
  end;
end;

procedure THero.UseTransPower;
begin
  FStartPower := FTransPower;
  FNeedPower := FTransPower - TransPowerConsumption + TransPowerRecovery * ADuration;
  FTime := 0;
  FUseDuration := ADuration;
  FIsUsePower := True;
end;
{$ENDREGION}

{$REGION '  THero Ship  '}
constructor THeroShip.CreateUnit(const APosition: TVector2F; AAngle: Single; ASide: TLifeFraction);
begin
  inherited;

  FCannon := TCannon.Create(oPlayer, 0.1, 20);
  FLauncher := TLauncher.Create(oPlayer, 0.7, 80, 300);
  FScanner := TScanner.Create;
  FAngularSpeed := 20;
  FRadius := 35;
  FHeroMaxSpeed := 40;
  FUseCollistion := True;
  FMass := 1;
  FOldPosition := FPosition;
  FInstance := Self;
end;

destructor THeroShip.Destroy;
begin
  FreeAndNil(FCannon);
  FreeAndNil(FLauncher);
  FreeAndNil(FScanner);
end;

class function THeroShip.GetInstance: THeroShip;
begin
  Result := FInstance;
end;

procedure THeroShip.OnDraw;
var
  ShieldAlpha: Byte;
begin
  TheResources.HeroTexture.Draw(FPosition, Vec2F(56, 56), FAngle, $FFFFFFFF);
  TheResources.MachineGunTexture.Draw(FPosition, Vec2F(19, 51), FTowerAngle, $FFFFFFFF);
  ShieldAlpha := Trunc(FShowShieldTime * $52);
  TheResources.FieldTexture.Draw(FPosition, Vec2F(70, 70), FTowerAngle, ShieldAlpha * $1000000 + $FFFFFF);
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
  FLauncher.OnUpdate(ADelta);

  AShift := FOldPosition - Position;
  FOldPosition := Position;
  AShift := AShift * 0.3;
  TheEngine.Camera.Position := FPosition;
  if THero.FInstance.FLife < DEFAULT_LIFE then
  begin
    THero.FInstance.FLife := THero.FInstance.FLife + ADelta * LIFE_ADDITION;
  end;
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

procedure THeroShip.OnCollide(AObject: TPhysicalObject);
begin
  if (AObject is TAsteroid) then
  begin
    FShowShieldTime := 0.7;
  end;
  if (AObject is TBaseEnemy) then
  begin
    FShowShieldTime := 0.7;
  end;
end;

procedure THeroShip.Hit(ADamage: Single);
begin
  FShowShieldTime := 0.7;
  THero.FInstance.FLife := THero.FInstance.FLife - ADamage;
  if (THero.FInstance.FLife <= 0) then
  begin
    TFluid.EmmitFluids(THero.GetInstance.FFluid[0], FPosition, fYellow);
    TFluid.EmmitFluids(THero.GetInstance.FFluid[1], FPosition, fGreen);
    TFluid.EmmitFluids(THero.GetInstance.FFluid[2], FPosition, fBlue);
    TFluid.EmmitFluids(THero.GetInstance.FFluid[3], FPosition, fRed);
    //Kill;
    THero.GetInstance.KillPlayer;
    FPosition := Vec2F(Random(10000) - 5000, Random(10000) - 5000);
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
  if TheMouseState.IsButtonPressed[mbRight] then
    FLauncher.Fire(FPosition, TheEngine.Camera.GetWorldPos(TheControlState.Mouse.Position), FAngle);
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
