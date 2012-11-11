unit QGame.SceneManager;

interface

uses
  Generics.Collections,
  QCore.Types,
  QCore.Input,
  QGame.Scene,
  Strope.Math;

type
  TSceneManager = class sealed (TComponent)
    strict private
      FScenes: TDictionary<string, TScene>;
      FCurrentScene: TScene;

      function GetScene(const ASceneName: string): TScene;
    public
      constructor Create;
      destructor Destroy; override;

      procedure AddScene(AScene: TScene);
      procedure MakeCurrent(const ASceneName: string);
      procedure DeleteScene(const ASceneName: string);

      ///<summary>����� ���������� ��� ������������� ������� �����.</summary>
      ///<param name="AParameter">������-�������� ��� �������������.</param>
      procedure OnInitialize(AParameter: TObject = nil); override;

      ///<summary>����� ������ ��� ��������� ��� ����������� ������� �����.</summary>
      ///<param name="AIsActivate">�������� True ������ ��� ���������,
      ///�������� False - ��� �����������.</param>
      procedure OnActivate(AIsActivate: Boolean); override;

      ///<summary>����� ���������� ��� ��������� ������� �����.</summary>
      ///<param name="ALayer">���� ����� ��� ���������.</param>
      procedure OnDraw(const ALayer: Integer); override;

      ///<summary>����� ���������� ��� ���������� ��������� ������� �����.</summary>
      ///<param name="ADelta">���������� ������� � ��������,
      ///��������� � ����������� ���������� ���������.</param>
      procedure OnUpdate(const ADelta: Double); override;

      ///<summary>����� ������ ���������� (������� ��� � �����������) ��� ��� ����� ��������� ������� �����.
      /// ������ ��� ������� ������� ������ ��������.</summary>
      procedure OnDestroy; override;

      ///<summary>����� ���������� ��� ������� �� ������� "�������� �����"</summary>
      ///<param name="AMousePosition">������� ���������� ����,
      ///������������ ������ �������� ���� �������� ����.</param>
      ///<returns>������������ ���������� �������� ������������� � ���,
      ///���� �� ������� ���������� ��������.</returns>
      function OnMouseMove(const AMousePosition: TVectorF): Boolean; override;

      ///<summary>����� ���������� ��� ������� �� ������� <b><i>������� ������ ����</i></b></summary>
      ///<param name="AButton">������� ������ ����.</param>
      ///<param name="AMousePosition">���������� ���� � ������ ������� ������,
      ///������������ ������ �������� ���� �������� ����.</param>
      ///<returns>������������ ���������� �������� ������������� � ���,
      ///���� �� ������� ���������� ��������.</returns>
      ///<remarks>�������� ������������ <see creg="QCore.Input|TMouseButton" />
      /// ����� ����� � ������ QCore.Input.</remarks>
      function OnMouseButtonDown(
        AButton: TMouseButton; const AMousePosition: TVectorF): Boolean; override;

      ///<summary>����� ���������� ��� ������� �� ������� <b><i>���������� ������ ����</i></b></summary>
      ///<param name="AButton">���������� ������ ����.</param>
      ///<param name="AMousePosition">���������� ���� � ������ ���������� ������,
      /// ������������ ������ �������� ���� �������� ����.</param>
      ///<returns>������������ ���������� �������� ������������� � ���,
      ///���� �� ������� ���������� ��������.</returns>
      ///<remarks>�������� ������������ <see creg="QCore.Input|TMouseButton" />
      /// ����� ����� � ������ QCore.Input.</remarks>
      function OnMouseButtonUp(
        AButton: TMouseButton; const AMousePosition: TVectorF): Boolean; override;

      ///<summary>����� ���������� ��� ������� �� ������� <b><i>��������� ������ ���� ����</i></b></summary>
      ///<param name="ADirection">����������� ��������� ������.
      /// �������� +1 ������������� ��������� �����, -1 - ����.</param>
      ///<returns>������������ ���������� �������� ������������� � ���,
      ///���� �� ������� ���������� ��������.</returns>
      function OnMouseWheel(ADirection: Integer): Boolean; override;

      ///<summary>����� ���������� ��� ������ �� ������� <b><i>������� ������ �� ����������</i></b></summary>
      ///<param name="AKey">������� ������ �� ����������.</param>
      ///<returns>������������ ���������� �������� ������������� � ���,
      ///���� �� ������� ���������� ��������.</returns>
      ///<remarks>�������� �������� TKeyButton ����� ����� � ������ uInput.</remarks>
      function OnKeyDown(AKey: TKeyButton): Boolean; override;

      ///<summary>����� ���������� ��� ������ �� ������� <b><i>���������� ������ �� ����������</i></b></summary>
      ///<param name="AKey">���������� ������ �� ����������.</param>
      ///<returns>������������ ���������� �������� ������������� � ���,
      ///���� �� ������� ���������� ��������.</returns>
      ///<remarks>�������� �������� TKeyButton ����� ����� � ������ uInput.</remarks>
      function OnKeyUp(AKey: TKeyButton): Boolean; override;
    public
  end;

implementation

uses
  SysUtils;

{$REGION '  TSceneManager  '}
constructor TSceneManager.Create;
begin
  FScenes := TDictionary<string, TScene>.Create;
  FCurrentScene := nil;
end;

destructor TSceneManager.Destroy;
var
  AScene: TScene;
begin
  for AScene in FScenes.Values do
  begin
    AScene.OnDestroy;
    AScene.Free;
  end;
  FScenes.Free;

  inherited;
end;

function TSceneManager.GetScene(const ASceneName: string): TScene;
begin
  Result := nil;
  FScenes.TryGetValue(AnsiUpperCase(ASceneName), Result);
end;

procedure TSceneManager.AddScene(AScene: TScene);
begin
  if Assigned(AScene) then
  begin
    if Assigned(GetScene(AScene.Name)) then
      raise EArgumentException.Create(
        '����� � ����� ������ ��� ����������. ' +
        '{0CAED87C-8402-47EA-A245-4BAA77905A23}');

    FScenes.Add(AScene.Name, AScene);
  end;
end;

procedure TSceneManager.MakeCurrent(const ASceneName: string);
begin
  FCurrentScene := GetScene(ASceneName);
end;

procedure TSceneManager.DeleteScene(const ASceneName: string);
var
  AScene: TScene;
begin
  AScene := GetScene(ASceneName);
  if Assigned(AScene) then
  begin
    if FCurrentScene = AScene then
      FCurrentScene := nil;
    FScenes.Remove(AScene.Name);
    AScene.OnDestroy;
    FreeAndNil(AScene);
  end;
end;

procedure TSceneManager.OnActivate(AIsActivate: Boolean);
begin
  if Assigned(FCurrentScene) then
    FCurrentScene.OnActivate(AIsActivate);
end;

procedure TSceneManager.OnDestroy;
begin
  if Assigned(FCurrentScene) then
    FCurrentScene.OnDestroy;
end;

procedure TSceneManager.OnDraw(const ALayer: Integer);
begin
  if Assigned(FCurrentScene) then
    FCurrentScene.OnDraw(ALayer);
end;

procedure TSceneManager.OnInitialize(AParameter: TObject);
begin
  if Assigned(FCurrentScene) then
    FCurrentScene.OnInitialize(AParameter);
end;

function TSceneManager.OnKeyDown(AKey: TKeyButton): Boolean;
begin
  Result := True;
  if Assigned(FCurrentScene) then
    Result := FCurrentScene.OnKeyDown(AKey);
end;

function TSceneManager.OnKeyUp(AKey: TKeyButton): Boolean;
begin
  Result := True;
  if Assigned(FCurrentScene) then
    Result := FCurrentScene.OnKeyUp(AKey);
end;

function TSceneManager.OnMouseButtonDown(AButton: TMouseButton;
  const AMousePosition: TVectorF): Boolean;
begin
  Result := True;
  if Assigned(FCurrentScene) then
    Result := FCurrentScene.OnMouseButtonDown(AButton, AMousePosition);
end;

function TSceneManager.OnMouseButtonUp(AButton: TMouseButton;
  const AMousePosition: TVectorF): Boolean;
begin
  Result := True;
  if Assigned(FCurrentScene) then
    Result := FCurrentScene.OnMouseButtonUp(AButton, AMousePosition);
end;

function TSceneManager.OnMouseMove(const AMousePosition: TVectorF): Boolean;
begin
  Result := True;
  if Assigned(FCurrentScene) then
    Result := FCurrentScene.OnMouseMove(AMousePosition);
end;

function TSceneManager.OnMouseWheel(ADirection: Integer): Boolean;
begin
  Result := True;
  if Assigned(FCurrentScene) then
    Result := FCurrentScene.OnMouseWheel(ADirection)
end;

procedure TSceneManager.OnUpdate(const ADelta: Double);
begin
  if Assigned(FCurrentScene) then
    FCurrentScene.OnUpdate(ADelta);
end;

end.
