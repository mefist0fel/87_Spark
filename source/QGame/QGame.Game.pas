unit QGame.Game;

interface

uses
  QCore.Input,
  QCore.Types,
  QGame.SceneManager,
  QGame.ResourceManager,
  Strope.Math;

type
  TQGame = class (TComponent)
    strict protected
      FGameName: string;
      FGameAutors: string;
      FGameVersion: Integer;
      FGameVersionMajor: Integer;
      FGameVersionMinor: Integer;

      FSceneManager: TSceneManager;
      FResourceManager: TResourceManager;

      function GetGameVersion(): string; virtual;
      function GetGameName(): string; virtual;
    public
      constructor Create;
      destructor Destroy; override;

      ///<summary>����� ���������� ��� ������������� ����</summary>
      ///<param name="AParameter">������-�������� ��� �������������.</param>
      procedure OnInitialize(AParameter: TObject = nil); override;

      ///<summary>����� ������ ��� ��������� ������ ����� ��� ����.</summary>
      ///<param name="AIsActivate">�������� True ������ ��� ��������� ������ �����,
      ///�������� False - ��� �����������.</param>
      ///<remarks>����� ����� ����� �� �������������� ������� ������� ������,
      /// ������� ������� ����� ������ ����� �������������.</remarks>
      procedure OnActivate(AIsActivate: Boolean); override;

      ///<summary>����� ���������� ��� ��������� ������� ������� �����.</summary>
      ///<param name="ALayer">���� ����� ��� ���������.</param>
      procedure OnDraw(const ALayer: Integer); override;

      ///<summary>����� ���������� ��� ���������� ��������� ����.</summary>
      ///<param name="ADelta">���������� ������� � ��������,
      ///��������� � ����������� ���������� ���������.</param>
      procedure OnUpdate(const ADelta: Double); override;

      ///<summary>����� ������ ���������� (������� ��� � �����������) ��� ��� ����� ��������� ����.
      /// ������ ��� ������� ������� ����� ��������.</summary>
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

      property Name: string read GetGameName;
      property Version: string read GetGameVersion;
      property SceneManager: TSceneManager read FSceneManager;
      property ResourceManager: TResourceManager read FResourceManager;
  end;

var
  TheGame: TQGame = nil;
  TheSceneManager: TSceneManager = nil;
  TheResourceManager: TResourceManager = nil;

implementation

uses
  SysUtils;

{$REGION '  TQGame  '}
constructor TQGame.Create;
begin
  FGameName := 'Quad Game';
  FGameAutors := 'unknown';
  FGameVersion := 0;
  FGameVersionMajor := 0;
  FGameVersionMinor := 1;

  FSceneManager := TSceneManager.Create;
  FResourceManager := TResourceManager.Create;

  TheGame := Self;
  TheSceneManager := SceneManager;
  TheResourceManager := ResourceManager;
end;

destructor TQGame.Destroy;
begin
  FreeAndNil(FSceneManager);
  FreeAndNil(FResourceManager);

  TheGame := nil;
  TheSceneManager := nil;
  TheResourceManager := nil;

  inherited;
end;

function TQGame.GetGameVersion;
begin
  Result := 'v ' + IntToStr(FGameVersion) + '.' +
    IntToStr(FGameVersionMajor) + '.' + IntToStr(FGameVersionMinor);
end;

function TQGame.GetGameName;
begin
  Result := FGameName + ' by ' + FGameAutors;
end;

procedure TQGame.OnInitialize(AParameter: TObject = nil);
begin
  //nothing to do
end;

procedure TQGame.OnActivate(AIsActivate: Boolean);
begin
  SceneManager.OnActivate(AIsActivate);
end;

procedure TQGame.OnDraw(const ALayer: Integer);
begin
  SceneManager.OnDraw(ALayer);
end;

procedure TQGame.OnUpdate(const ADelta: Double);
begin
  SceneManager.OnUpdate(ADelta);
end;

procedure TQGame.OnDestroy;
begin
  //nothing to do
end;

function TQGame.OnMouseMove(const AMousePosition: TVector2F): Boolean;
begin
  Result := SceneManager.OnMouseMove(AMousePosition);
end;

function TQGame.OnMouseButtonDown(AButton: TMouseButton;
  const AMousePosition: TVector2F): Boolean;
begin
  Result := SceneManager.OnMouseButtonDown(AButton, AMousePosition);
end;

function TQGame.OnMouseButtonUp(AButton: TMouseButton;
  const AMousePosition: TVector2F): Boolean;
begin
  Result := SceneManager.OnMouseButtonUp(AButton, AMousePosition);
end;

function TQGame.OnMouseWheel(ADirection: Integer): Boolean;
begin
  Result := SceneManager.OnMouseWheel(ADirection);
end;

function TQGame.OnKeyDown(AKey: Word): Boolean;
begin
  Result := SceneManager.OnKeyDown(AKey);
end;

function TQGame.OnKeyUp(AKey: Word): Boolean;
begin
  Result := SceneManager.OnKeyUp(AKey);
end;
{$ENDREGION}

end.
