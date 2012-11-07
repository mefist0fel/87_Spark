unit QEngine.Camera;

interface

uses
  Strope.Math;

type
  ///<summary>��������� ��������������� ����������� ��������� ���������� ������
  /// � ����� ����������� �������� ���������� �������� � ������� � ��������
  /// � ��������</summary>
  IQuadCamera = interface (IUnknown)
    function GetPosition(): TVectorF;
    procedure SetPosition(const APosition: TVectorF);

    function GetCenterPosition(): TVectorF;
    procedure SetCenterPosition(const APosition: TVectorF);

    function GetScale(): TVectorF;
    procedure SetScale(const AScale: TVectorF);

    function GetResolutionCorrection(): TVectorF;

    function GetIsUseCorrection(): Boolean;
    procedure SetIsUseCorrection(AIsUseCorrection: Boolean);

    ///<summary>����������� ���������� ���������� � ��������.</summary>
    ///<param name="AWorldPosition">���������� ���������� ��������� �����</param>
    ///<returns>�������� ���������� ����������� ��������� � ������� ������.</returns>
    function GetScreenPosition(const AWorldPosition: TVectorF): TVectorF;
    ///<summary>����������� ���������� ���������� �� ��� X � ��������.</summary>
    ///<param name="AWorldX">���������� ���������� ��������� ����� �� ��� X</param>
    ///<returns>�������� ���������� �� ��� X ����������� ��������� � ������� ������.</returns>
    function GetScreenX(AWorldX: Single): Single;
    ///<summary>����������� ���������� ���������� �� ��� Y � ��������.</summary>
    ///<param name="AWorldY">���������� ���������� ��������� ����� �� ��� Y</param>
    ///<returns>�������� ���������� �� ��� Y ����������� ��������� � ������� ������.</returns>
    function GetScreenY(AWordlY: Single): Single;

    ///<summary>����������� ���������� ������ � ��������.</summary>
    ///<param name="AWorldSize">���������� ������ ��������� �������.</param>
    ///<returns>�������� ������ ����������� ������� ������.</returns>
    function GetScreenSize(const AWorldSize: TVectorF): TVectorF;
    ///<summary>����������� ���������� ������ � ��������.</summary>
    ///<param name="AWorldWidth">���������� ������ ��������� �������.</param>
    ///<returns>�������� ������ ����������� ������� ������.</returns>
    function GetScreenWidth(AWorldWidth: Single): Single;
    ///<summary>����������� ���������� ������ � ��������.</summary>
    ///<param name="AWorldHeight">���������� ������ ��������� �������.</param>
    ///<returns>�������� ������ ����������� ������� ������.</returns>
    function GetScreenHeight(AWorldHeight: Single): Single;

    ///<summary>����������� �������� ���������� � ����������.</summary>
    ///<param name="ASreenPosition">�������� ���������� ��������� �����</param>
    ///<returns>���������� ���������� ����������� ��������� � ������� ������.</returns>
    function GetWorldPosition(const AScreenPosition: TVectorF): TVectorF;
    ///<summary>����������� �������� ���������� �� ��� X � ����������.</summary>
    ///<param name="AScreenX">�������� ���������� ��������� ����� �� ��� X</param>
    ///<returns>���������� ���������� �� ��� X ����������� ��������� � ������� ������.</returns>
    function GetWorldX(ASreenX: Single): Single;
    ///<summary>����������� �������� ���������� �� ��� Y � ����������.</summary>
    ///<param name="AScreenY">�������� ���������� ��������� ����� �� ��� Y</param>
    ///<returns>���������� ���������� �� ��� Y ����������� ��������� � ������� ������.</returns>
    function GetWorldY(AScrenY: Single): Single;

    ///<summary>����������� �������� ������ � ����������.</summary>
    ///<param name="AScreenSize">�������� ������ ��������� �������.</param>
    ///<returns>���������� ������ ����������� ������� ������.</returns>
    function GetWorldSize(const AScreenSize: TVectorF): TVectorF;
    ///<summary>����������� �������� ������ � ����������.</summary>
    ///<param name="AWorldWidth">�������� ������ ��������� �������.</param>
    ///<returns>���������� ������ ����������� ������� ������.</returns>
    function GetWorldWidth(AScreenWidth: Single): Single;
    ///<summary>����������� �������� ������ � ����������.</summary>
    ///<param name="AWorldHeight">�������� ����� ��������� �������.</param>
    ///<returns>���������� ������ ����������� ������� ������.</returns>
    function GetWorldHeight(AScreenHeight: Single): Single;

    ///<summary>������� ������.</summary>
    ///<remarks>������� ������ ������������� ������ �������� ���� ������.</remarks>
    property Position: TVectorF read GetPosition write SetPosition;
    property CenterPosition: TVectorF read GetCenterPosition write SetCenterPosition;
    ///<summary>���������� ����������� ������ �� ����.</summary>
    ///<remarks>��� ������� ������������� �������� �������� ��� ������� �� ������.</remarks>
    property Scale: TVectorF read GetScale write SetScale;
    ///<summary>����������� ��������� ����������. ���������� �� ������� ���
    /// ����� �� ��������� ������ ���� ������ ��� ������, ��� �� ���������
    /// � ������� �����.</summary>
    ///<remarks>��������� �� ��������� ��������, ������ ����� ������������� ������
    /// � ���������� � ������ ������������� ������������ ���������, ��� ���
    /// ��� �������� �������� �������� ��������� �� �������� ���� � ������
    /// ������� ����������� ������������ ������� (1, 1). ��� �����
    /// ��������� ��������, ��������, ��� ��������� ���������� ���
    /// ������ ������ ��������������� ������������ ������ ���������,
    /// ������� ������ � ��� ������ ����� ���������� ������������� ������� ������������
    /// ��������� ���������� ������.</remarks>
    property ResolutionCorrection: TVectorF read GetResolutionCorrection;
    ///<summary>����, ���������������, ����������� �� ��������� ����������
    /// ��� ���������.</summary>
    ///<seealso cref="QEngine.Camera|IQuadCamera.ResolutionCorrectin" />
    property IsUseCorrection: Boolean read GetIsUseCorrection write SetIsUseCorrection;
  end;

implementation

end.
