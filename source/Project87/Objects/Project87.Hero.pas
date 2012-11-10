unit Project87.Hero;

interface

uses
  QEngine.Camera,
  QGame.Scene,
  Strope.Math,
  Project87.Types.GameObject;

type
  THero = class (TGameObject)
    private
      FTowerAngle: Single;
      FNeedAngle: Single;
      FNeedCameraPosition: TVector2F;
      FMoveDirection: TVector2F;
      FHeroMaxSpeed: Single;
      FNeedSpeed: Single;
      FSpeed: Single;
      FMessage: String;
      procedure Control(const  ADelta: Double);
      procedure CheckKeys;
    public
      constructor CreateHero( APosition: TVector2F);

      procedure OnDraw; override;
      procedure OnUpdate(const  ADelta: Double); override;
      procedure OnCollide(OtherObject: TGameObject); override;
  end;

implementation

uses
  QuadEngine,
  SysUtils,
  QEngine.Core,
  QCore.Input,
  QApplication.Application,
  Project87.Asteroid,
  Project87.Fluid,
  Project87.Resources;

{$REGION '  THero  '}
constructor THero.CreateHero( APosition: TVector2F);
begin
  inherited Create;
  FPosition := APosition;
  FRadius := 35;
  FHeroMaxSpeed := 80;
  FUseCollistion := True;
  FMass := 1;
  FMessage := '';
end;

procedure THero.OnDraw;
begin
<<<<<<< HEAD
  TheResources.HeroTexture.Draw(FPosition, TVector2F.Create(50, 50), FAngle, $FFFFFFFF);
  TheResources.HeroTexture.Draw(FPosition, TVector2F.Create(50, 50), FTowerAngle, $FFFFFFFF);
=======
  TheResources.HeroTexture.Draw(FPosition, TVector2F.Create(30, 50), FAngle, $ffffffff);
  TheResources.HeroTexture.Draw(FPosition, TVector2F.Create(10, 20), FTowerAngle, $ffffffff);
  TheResources.AsteroidTexture.Draw(FPosition, TVector2F.Create(70, 70), FTowerAngle, $22ffffff);
  TheResources.Font.TextOut(FMessage, FPosition, 2);
>>>>>>> 555ee598794442d6cecf0955ef65720a4770c45d
end;

procedure THero.OnUpdate(const  ADelta: Double);
begin
  CheckKeys;
  FAngle := RotateToAngle(FAngle, FNeedAngle, 220 * ADelta);
  FSpeed := FSpeed * (1 - ADelta * 50) + FNeedSpeed * (ADelta * 50);
  FVelocity := FVelocity + ClipAndRotate(FAngle, FSpeed);
  if FVelocity.Length > 1400 then
    FVelocity := FVelocity * (1400 / FVelocity.Length);
  Control(ADelta);
end;

procedure THero.OnCollide(OtherObject: TGameObject);
begin
  if (OtherObject is TAsteroid) then
    FMessage := 'Asteroid';
//  if (OtherObject is TFluid) then
//    FMessage := 'Fluid';
end;

procedure THero.Control(const  ADelta: Double);
var
  MousePosition: TVector2F;
  DistanceToCamera: Single;
begin
  MousePosition := TheEngine.Camera.GetWorldPos(TheControlState.Mouse.Position);
  FTowerAngle := GetAngle(FPosition, MousePosition);
  DistanceToCamera := ((MousePosition - FPosition).Length) / 500;
  if DistanceToCamera < 1 then
    DistanceToCamera := 1;

  FNeedCameraPosition := (MousePosition - FPosition) * (0.5 / DistanceToCamera) + FPosition;
  TheEngine.Camera.Position := TheEngine.Camera.Position * (1 - ADelta * 20) + FNeedCameraPosition * (ADelta * 20);
end;

procedure THero.CheckKeys;
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
  if TheControlState.Keyboard.IsKeyPressed[KB_A] or
     TheControlState.Keyboard.IsKeyPressed[KB_LEFT] then
    FNeedAngle := RoundAngle(FNeedAngle - 20);
  if TheControlState.Keyboard.IsKeyPressed[KB_D] or
     TheControlState.Keyboard.IsKeyPressed[KB_RIGHT] then
    FNeedAngle := RoundAngle(FNeedAngle + 20);
  if TheControlState.Keyboard.IsKeyPressed[KB_W] or
     TheControlState.Keyboard.IsKeyPressed[KB_UP] then
    FNeedSpeed := FHeroMaxSpeed;
end;
{$ENDREGION}

end.
