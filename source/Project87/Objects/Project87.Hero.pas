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
      FNeedCameraPosition: TVector2F;
      FMoveDirection: TVector2F;
      FMoveSpeed: Single;
      procedure Control(const  ADelta: Double);
      procedure Move(const  ADelta: Double);
      procedure CheckKeys;
    public
      constructor Create( APosition: TVector2F);
      procedure OnDraw; override;
      procedure OnUpdate(const  ADelta: Double); override;
  end;

implementation

uses
  QuadEngine,
  SysUtils,
  QEngine.Core,
  QCore.Input,
  QApplication.Application,
  Project87.Resources;

{$REGION '  THero  '}
constructor THero.Create( APosition: TVector2F);
begin
  FPosition := APosition;
  inherited Create;
end;

procedure THero.OnDraw;
begin
  TheResources.HeroTexture.Draw(FPosition, TVector2F.Create(40, 60), FAngle, $ffffffff);
  TheResources.HeroTexture.Draw(FPosition, TVector2F.Create(20, 30), FTowerAngle, $ffffffff);
  TheResources.HeroTexture.Draw(TheEngine.Camera.GetWorldPosition(TheControlState.Mouse.Position), TVector2F.Create(10, 10), FAngle, $ffffffff);
  TheResources.Font.TextOut(FloatToStr(FMoveDirection.X), TVector2F.Create(10, 10), 2);
end;

procedure THero.Control(const  ADelta: Double);
var
  MousePosition: TVector2F;
  DistanceToCamera: Single;
begin
  MousePosition := TheEngine.Camera.GetWorldPosition(TheControlState.Mouse.Position - TheEngine.Camera.Position);
  FTowerAngle := AngleBetween(FPosition, MousePosition);
  DistanceToCamera := ((MousePosition - TheEngine.Camera.Position).Length);
  FNeedCameraPosition := MousePosition * (0.5);// + FPosition;
  TheEngine.Camera.Position := TheEngine.Camera.Position * (0.9 - ADelta) + FNeedCameraPosition * (0.1 + ADelta);
end;

procedure THero.CheckKeys;
var
  NeedDirection: TVector2F;
  NeedSpeed: Single;
begin
  NeedDirection := ZeroVectorF;
  FMoveSpeed :=  550;
  if TheControlState.Keyboard.IsKeyPressed[KB_W] or
     TheControlState.Keyboard.IsKeyPressed[KB_UP] then
    NeedDirection := NeedDirection + TVector2F.Create(0, -1);
  if TheControlState.Keyboard.IsKeyPressed[KB_S] or
     TheControlState.Keyboard.IsKeyPressed[KB_DOWN] then
    NeedDirection := NeedDirection + TVector2F.Create(0, 1);
  if TheControlState.Keyboard.IsKeyPressed[KB_A] or
     TheControlState.Keyboard.IsKeyPressed[KB_LEFT] then
    NeedDirection := NeedDirection + TVector2F.Create(-1, 0);
  if TheControlState.Keyboard.IsKeyPressed[KB_D] or
     TheControlState.Keyboard.IsKeyPressed[KB_RIGHT] then
    NeedDirection := NeedDirection + TVector2F.Create(1, 0);
  if NeedDirection = ZeroVectorF then
    FMoveDirection := ZeroVectorF
  else
    FMoveDirection := NeedDirection.Normalized * FMoveSpeed;

end;

procedure THero.Move(const  ADelta: Double);
begin
  FPosition := FPosition + FVelocity * ADelta;
end;

procedure THero.OnUpdate(const  ADelta: Double);
begin
  Control(ADelta);
  CheckKeys;
  FVelocity := FVelocity * 0.95 + FMoveDirection * 0.05;
  Move(ADelta);
end;
{$ENDREGION}

end.
