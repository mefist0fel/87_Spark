unit QCore.Types;

interface

uses
  QuadEngine,
  QCore.Input,
  Strope.Math;

type
  ///<summary>������� ��� ��� ������������� ��������.</summary>
  TObjectId = Cardinal;

  ///<summary>������� ����� ��� ���� ������� �������,
  /// ����������� �����-���� ����������.</summary>
  TBaseObject = class abstract (TObject, IInterface)
    strict protected
      FRefCount: Integer;

      function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
      function _AddRef: Integer; stdcall;
      function _Release: Integer; stdcall;
    public
      destructor Destroy; override;

      property RefCount: Integer read FRefCount;
  end;

  ///<summary>������� ��������� ��� ��������,
  /// ������������ ������ ��� ������� �� �������� �������</summary>
  IBaseActions = interface (IUnknown)
    ///<summary>����� ���������� ��� ������������� �������.</summary>
    ///<param name="AParameter">������-�������� ��� �������������.</param>
    procedure OnInitialize(AParameter: TObject = nil);

    ///<summary>����� ������ ��� ��������� ��� ����������� �������.</summary>
    ///<param name="AIsActivate">�������� True ������ ��� ��������� �������,
    ///�������� False - ��� �����������.</param>
    procedure OnActivate(AIsActivate: Boolean);

    ///<summary>����� ���������� ��� ��������� �������.</summary>
    ///<param name="ALayer">���� ������� ��� ���������.</param>
    procedure OnDraw(const ALayer: Integer);

    ///<summary>����� ���������� ��� ���������� ��������� �������.</summary>
    ///<param name="ADelta">���������� ������� � ��������,
    ///��������� � ����������� ���������� ���������.</param>
    procedure OnUpdate(const ADelta: Double);

    ///<summary>����� ������ ���������� (������� ��� � �����������) ��� ��� ����� ��������� �������.
    /// ������ ��� ������� ������� �������� ��������.</summary>
    procedure OnDestroy;
  end;

  ///<summary>������� ��������� ��� ��������,
  /// ������������ ������ ��� ������� �� ������� �����-������.</summary>
  IInputActions = interface (IUnknown)
    ///<summary>����� ���������� ��� ������� �� ������� "�������� �����"</summary>
    ///<param name="AMousePosition">������� ���������� ����,
    ///������������ ������ �������� ���� �������� ����.</param>
    ///<returns>������������ ���������� �������� ������������� � ���,
    ///���� �� ������� ���������� ��������.</returns>
    function OnMouseMove(const AMousePosition: TVectorF): Boolean;

    ///<summary>����� ���������� ��� ������� �� ������� <b><i>������� ������ ����</i></b></summary>
    ///<param name="AButton">������� ������ ����.</param>
    ///<param name="AMousePosition">���������� ���� � ������ ������� ������,
    ///������������ ������ �������� ���� �������� ����.</param>
    ///<returns>������������ ���������� �������� ������������� � ���,
    ///���� �� ������� ���������� ��������.</returns>
    ///<remarks>�������� ������������ <see creg="QCore.Input|TMouseButton" />
    /// ����� ����� � ������ QCore.Input.</remarks>
    function OnMouseButtonDown(
      AButton: TMouseButton; const AMousePosition: TVectorF): Boolean;

    ///<summary>����� ���������� ��� ������� �� ������� <b><i>���������� ������ ����</i></b></summary>
    ///<param name="AButton">���������� ������ ����.</param>
    ///<param name="AMousePosition">���������� ���� � ������ ���������� ������,
    /// ������������ ������ �������� ���� �������� ����.</param>
    ///<returns>������������ ���������� �������� ������������� � ���,
    ///���� �� ������� ���������� ��������.</returns>
    ///<remarks>�������� ������������ <see creg="QCore.Input|TMouseButton" />
    /// ����� ����� � ������ QCore.Input.</remarks>
    function OnMouseButtonUp(
      AButton: TMouseButton; const AMousePosition: TVectorF): Boolean;

    ///<summary>����� ���������� ��� ������� �� ������� <b><i>��������� ������ ���� ����</i></b></summary>
    ///<param name="ADirection">����������� ��������� ������.
    /// �������� +1 ������������� ��������� �����, -1 - ����.</param>
    ///<param name="AMousePosition">���������� ���� � ������ ��������� ������,
    /// ������������ ������ �������� ���� �������� ����.</param>
    ///<returns>������������ ���������� �������� ������������� � ���,
    ///���� �� ������� ���������� ��������.</returns>
    function OnMouseWheel(ADirection: Integer): Boolean;

    ///<summary>����� ���������� ��� ������ �� ������� <b><i>������� ������ �� ����������</i></b></summary>
    ///<param name="AKey">������� ������ �� ����������.</param>
    ///<returns>������������ ���������� �������� ������������� � ���,
    ///���� �� ������� ���������� ��������.</returns>
    ///<remarks>�������� �������� TKeyButton ����� ����� � ������ uInput.</remarks>
    function OnKeyDown(AKey: TKeyButton): Boolean;

    ///<summary>����� ���������� ��� ������ �� ������� <b><i>���������� ������ �� ����������</i></b></summary>
    ///<param name="AKey">���������� ������ �� ����������.</param>
    ///<returns>������������ ���������� �������� ������������� � ���,
    ///���� �� ������� ���������� ��������.</returns>
    ///<remarks>�������� �������� TKeyButton ����� ����� � ������ uInput.</remarks>
    function OnKeyUp(AKey: TKeyButton): Boolean;
  end;

  ///<summary>������� ��� ��� ��������,
  /// ��������� ����������� �� �������� ������ � ������� �����-������.</summary>
  TComponent = class abstract (TBaseObject, IBaseActions, IInputActions)
    public
      ///<summary>����� ���������� ��� ������������� �������.</summary>
      ///<param name="AParameter">������-�������� ��� �������������.</param>
      procedure OnInitialize(AParameter: TObject = nil); virtual;

      ///<summary>����� ������ ��� ��������� ��� ����������� �������.</summary>
      ///<param name="AIsActivate">�������� True ������ ��� ��������� �������,
      ///�������� False - ��� �����������.</param>
      procedure OnActivate(AIsActivate: Boolean); virtual;

      ///<summary>����� ���������� ��� ��������� �������.</summary>
      ///<param name="ALayer">���� ������� ��� ���������.</param>
      procedure OnDraw(const ALayer: Integer); virtual;

      ///<summary>����� ���������� ��� ���������� ��������� �������.</summary>
      ///<param name="ADelta">���������� ������� � ��������,
      ///��������� � ����������� ���������� ���������.</param>
      procedure OnUpdate(const ADelta: Double); virtual;

      ///<summary>����� ������ ���������� (������� ��� � �����������) ��� ��� ����� ��������� �������.
      /// ������ ��� ������� ������� �������� ��������.</summary>
      procedure OnDestroy; virtual;

      ///<summary>����� ���������� ��� ������� �� ������� "�������� �����"</summary>
      ///<param name="AMousePosition">������� ���������� ����,
      ///������������ ������ �������� ���� �������� ����.</param>
      ///<returns>������������ ���������� �������� ������������� � ���,
      ///���� �� ������� ���������� ��������.</returns>
      function OnMouseMove(const AMousePosition: TVectorF): Boolean; virtual;

      ///<summary>����� ���������� ��� ������� �� ������� <b><i>������� ������ ����</i></b></summary>
      ///<param name="AButton">������� ������ ����.</param>
      ///<param name="AMousePosition">���������� ���� � ������ ������� ������,
      ///������������ ������ �������� ���� �������� ����.</param>
      ///<returns>������������ ���������� �������� ������������� � ���,
      ///���� �� ������� ���������� ��������.</returns>
      ///<remarks>�������� ������������ <see creg="QCore.Input|TMouseButton" />
      /// ����� ����� � ������ QCore.Input.</remarks>
      function OnMouseButtonDown(
        AButton: TMouseButton; const AMousePosition: TVectorF): Boolean; virtual;

      ///<summary>����� ���������� ��� ������� �� ������� <b><i>���������� ������ ����</i></b></summary>
      ///<param name="AButton">���������� ������ ����.</param>
      ///<param name="AMousePosition">���������� ���� � ������ ���������� ������,
      /// ������������ ������ �������� ���� �������� ����.</param>
      ///<returns>������������ ���������� �������� ������������� � ���,
      ///���� �� ������� ���������� ��������.</returns>
      ///<remarks>�������� ������������ <see creg="QCore.Input|TMouseButton" />
      /// ����� ����� � ������ QCore.Input.</remarks>
      function OnMouseButtonUp(
        AButton: TMouseButton; const AMousePosition: TVectorF): Boolean; virtual;

      ///<summary>����� ���������� ��� ������� �� ������� <b><i>��������� ������ ���� ����</i></b></summary>
      ///<param name="ADirection">����������� ��������� ������.
      /// �������� +1 ������������� ��������� �����, -1 - ����.</param>
      ///<param name="AMousePosition">���������� ���� � ������ ��������� ������,
      /// ������������ ������ �������� ���� �������� ����.</param>
      ///<returns>������������ ���������� �������� ������������� � ���,
      ///���� �� ������� ���������� ��������.</returns>
      function OnMouseWheel(ADirection: Integer): Boolean; virtual;

      ///<summary>����� ���������� ��� ������ �� ������� <b><i>������� ������ �� ����������</i></b></summary>
      ///<param name="AKey">������� ������ �� ����������.</param>
      ///<returns>������������ ���������� �������� ������������� � ���,
      ///���� �� ������� ���������� ��������.</returns>
      ///<remarks>�������� �������� TKeyButton ����� ����� � ������ uInput.</remarks>
      function OnKeyDown(AKey: TKeyButton): Boolean; virtual;

      ///<summary>����� ���������� ��� ������ �� ������� <b><i>���������� ������ �� ����������</i></b></summary>
      ///<param name="AKey">���������� ������ �� ����������.</param>
      ///<returns>������������ ���������� �������� ������������� � ���,
      ///���� �� ������� ���������� ��������.</returns>
      ///<remarks>�������� �������� TKeyButton ����� ����� � ������ uInput.</remarks>
      function OnKeyUp(AKey: TKeyButton): Boolean; virtual;
  end;

implementation

uses
  Windows;

{$REGION '  TBaseObject  '}
destructor TBaseObject.Destroy;
begin
  FRefCount := -1;
  inherited;
end;

function TBaseObject.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TBaseObject._AddRef: Integer;
begin
  Result := InterlockedIncrement(FRefCount);
  //FRefCount := 1;
end;

function TBaseObject._Release: Integer;
begin
  Result := InterlockedDecrement(FRefCount);
  if Result = 0 then
    Destroy;
  //FRefCount := 1;
end;
{$ENDREGION}

{$REGION '  TComponent  '}
procedure TComponent.OnActivate(AIsActivate: Boolean);
begin

end;

procedure TComponent.OnDestroy;
begin

end;

procedure TComponent.OnDraw(const ALayer: Integer);
begin

end;

procedure TComponent.OnInitialize(AParameter: TObject);
begin

end;

function TComponent.OnKeyDown(AKey: TKeyButton): Boolean;
begin
  Result := False;
end;

function TComponent.OnKeyUp(AKey: TKeyButton): Boolean;
begin
  Result := False;
end;

function TComponent.OnMouseButtonDown(AButton: TMouseButton;
  const AMousePosition: TVectorF): Boolean;
begin
  Result := False;
end;

function TComponent.OnMouseButtonUp(AButton: TMouseButton;
  const AMousePosition: TVectorF): Boolean;
begin
  Result := False;
end;

function TComponent.OnMouseMove(const AMousePosition: TVectorF): Boolean;
begin
  Result := False;
end;

function TComponent.OnMouseWheel(ADirection: Integer): Boolean;
begin
  Result := False;
end;

procedure TComponent.OnUpdate(const ADelta: Double);
begin

end;
{$ENDREGION}

end.

