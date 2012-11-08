unit Project87.Types.GameObject;

interface

uses
  Generics.Collections,
  SysUtils,
  Strope.Math;

type
  TObjectManager = class;

  TGameObject = class
    protected
      FParent: TObjectManager;
      FAngle: Single;
      FPosition: TVector2F;
      FVelocity: TVector2F;
    public
      constructor Create; virtual;
      destructor Destroy; virtual;
      procedure OnDraw; virtual;
      procedure OnUpdate(const  ADelta: Double); virtual;
      property Manager: TObjectManager read FParent;
  end;

  TObjectManager = class
    private class var FInstance: TObjectManager;
    private
      FObject: TList<TGameObject>;
      constructor Create;
      destructor Destroy;
      procedure DestroyObject(AObject: TGameObject);
      procedure AddObject(AObject: TGameObject);
    public
      class function GetInstance: TObjectManager;
      procedure OnDraw;
      procedure OnUpdate(const ADelta: Double);
  end;

implementation

{$REGION '  TGameObject'}
constructor TGameObject.Create;
begin
  FParent := TObjectManager.GetInstance;
  FParent.AddObject(Self);
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

procedure TGameObject.OnUpdate(const  ADelta: Double);
begin

end;
{$ENDREGION}

{$REGION '  TObjectManager'}
constructor TObjectManager.Create;
begin
  FObject:= TList<TGameObject>.Create();
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
  Result:= FInstance;
end;

procedure TObjectManager.OnDraw;
var GameObject: TGameObject;
begin
  for GameObject in FObject do
    GameObject.OnDraw;
end;

procedure TObjectManager.OnUpdate(const ADelta: Double);
var GameObject: TGameObject;
begin
  for GameObject in FObject do
    GameObject.OnUpdate(ADelta);
end;
{$ENDREGION}

end.
