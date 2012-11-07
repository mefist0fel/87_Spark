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
  TBaseObject = class abstract (TInterfacedObject)
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
    function OnMouseWheel(ADirection: Integer; const AMousePosition: TVectorF): Boolean;

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
      procedure OnInitialize(AParameter: TObject = nil); virtual; abstract;

      ///<summary>����� ������ ��� ��������� ��� ����������� �������.</summary>
      ///<param name="AIsActivate">�������� True ������ ��� ��������� �������,
      ///�������� False - ��� �����������.</param>
      procedure OnActivate(AIsActivate: Boolean); virtual; abstract;

      ///<summary>����� ���������� ��� ��������� �������.</summary>
      ///<param name="ALayer">���� ������� ��� ���������.</param>
      procedure OnDraw(const ALayer: Integer); virtual; abstract;

      ///<summary>����� ���������� ��� ���������� ��������� �������.</summary>
      ///<param name="ADelta">���������� ������� � ��������,
      ///��������� � ����������� ���������� ���������.</param>
      procedure OnUpdate(const ADelta: Double); virtual; abstract;

      ///<summary>����� ������ ���������� (������� ��� � �����������) ��� ��� ����� ��������� �������.
      /// ������ ��� ������� ������� �������� ��������.</summary>
      procedure OnDestroy; virtual; abstract;

      ///<summary>����� ���������� ��� ������� �� ������� "�������� �����"</summary>
      ///<param name="AMousePosition">������� ���������� ����,
      ///������������ ������ �������� ���� �������� ����.</param>
      ///<returns>������������ ���������� �������� ������������� � ���,
      ///���� �� ������� ���������� ��������.</returns>
      function OnMouseMove(const AMousePosition: TVectorF): Boolean; virtual; abstract;

      ///<summary>����� ���������� ��� ������� �� ������� <b><i>������� ������ ����</i></b></summary>
      ///<param name="AButton">������� ������ ����.</param>
      ///<param name="AMousePosition">���������� ���� � ������ ������� ������,
      ///������������ ������ �������� ���� �������� ����.</param>
      ///<returns>������������ ���������� �������� ������������� � ���,
      ///���� �� ������� ���������� ��������.</returns>
      ///<remarks>�������� ������������ <see creg="QCore.Input|TMouseButton" />
      /// ����� ����� � ������ QCore.Input.</remarks>
      function OnMouseButtonDown(
        AButton: TMouseButton; const AMousePosition: TVectorF): Boolean; virtual; abstract;

      ///<summary>����� ���������� ��� ������� �� ������� <b><i>���������� ������ ����</i></b></summary>
      ///<param name="AButton">���������� ������ ����.</param>
      ///<param name="AMousePosition">���������� ���� � ������ ���������� ������,
      /// ������������ ������ �������� ���� �������� ����.</param>
      ///<returns>������������ ���������� �������� ������������� � ���,
      ///���� �� ������� ���������� ��������.</returns>
      ///<remarks>�������� ������������ <see creg="QCore.Input|TMouseButton" />
      /// ����� ����� � ������ QCore.Input.</remarks>
      function OnMouseButtonUp(
        AButton: TMouseButton; const AMousePosition: TVectorF): Boolean; virtual; abstract;

      ///<summary>����� ���������� ��� ������� �� ������� <b><i>��������� ������ ���� ����</i></b></summary>
      ///<param name="ADirection">����������� ��������� ������.
      /// �������� +1 ������������� ��������� �����, -1 - ����.</param>
      ///<param name="AMousePosition">���������� ���� � ������ ��������� ������,
      /// ������������ ������ �������� ���� �������� ����.</param>
      ///<returns>������������ ���������� �������� ������������� � ���,
      ///���� �� ������� ���������� ��������.</returns>
      function OnMouseWheel(ADirection: Integer;
        const AMousePosition: TVectorF): Boolean; virtual; abstract;

      ///<summary>����� ���������� ��� ������ �� ������� <b><i>������� ������ �� ����������</i></b></summary>
      ///<param name="AKey">������� ������ �� ����������.</param>
      ///<returns>������������ ���������� �������� ������������� � ���,
      ///���� �� ������� ���������� ��������.</returns>
      ///<remarks>�������� �������� TKeyButton ����� ����� � ������ uInput.</remarks>
      function OnKeyDown(AKey: TKeyButton): Boolean; virtual; abstract;

      ///<summary>����� ���������� ��� ������ �� ������� <b><i>���������� ������ �� ����������</i></b></summary>
      ///<param name="AKey">���������� ������ �� ����������.</param>
      ///<returns>������������ ���������� �������� ������������� � ���,
      ///���� �� ������� ���������� ��������.</returns>
      ///<remarks>�������� �������� TKeyButton ����� ����� � ������ uInput.</remarks>
      function OnKeyUp(AKey: TKeyButton): Boolean; virtual; abstract;
  end;

implementation

end.

