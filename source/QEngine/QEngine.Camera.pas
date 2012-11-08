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

    function GetLeftTopPosition(): TVectorF;
    procedure SetLeftTopPosition(const APosition: TVectorF);

    function GetScale(): TVectorF;
    procedure SetScale(const AScale: TVectorF);

    function GetCorrection(): TVectorF;

    function GetUseCorrection(): Boolean;
    procedure SetUseCorrection(AUseCorrection: Boolean);

    function GetResolution(): TVectorF;
    function GetDefaultResolution(): TVectorF;

    ///<summary>����������� ���������� ���������� � ��������.</summary>
    ///<param name="APosition">���������� ���������� ��������� �����</param>
    ///<returns>�������� ���������� ����������� ��������� � ������� ������.</returns>
    function GetScreenPosition(const APosition: TVectorF): TVectorF;
    ///<summary>����������� ���������� ���������� �� ��� X � ��������.</summary>
    ///<param name="X">���������� ���������� ��������� ����� �� ��� X</param>
    ///<returns>�������� ���������� �� ��� X ����������� ��������� � ������� ������.</returns>
    function GetScreenX(X: Single): Single;
    ///<summary>����������� ���������� ���������� �� ��� Y � ��������.</summary>
    ///<param name="Y">���������� ���������� ��������� ����� �� ��� Y</param>
    ///<returns>�������� ���������� �� ��� Y ����������� ��������� � ������� ������.</returns>
    function GetScreenY(Y: Single): Single;

    ///<summary>����������� ���������� ������ � ��������.</summary>
    ///<param name="ASize">���������� ������ ��������� �������.</param>
    ///<returns>�������� ������ ����������� ������� ������.</returns>
    function GetScreenSize(const ASize: TVectorF): TVectorF;
    ///<summary>����������� ���������� ������ � ��������.</summary>
    ///<param name="AWidth">���������� ������ ��������� �������.</param>
    ///<returns>�������� ������ ����������� ������� ������.</returns>
    function GetScreenWidth(AWidth: Single): Single;
    ///<summary>����������� ���������� ������ � ��������.</summary>
    ///<param name="AHeight">���������� ������ ��������� �������.</param>
    ///<returns>�������� ������ ����������� ������� ������.</returns>
    function GetScreenHeight(AHeight: Single): Single;

    ///<summary>����������� �������� ���������� � ����������.</summary>
    ///<param name="APosition">�������� ���������� ��������� �����</param>
    ///<returns>���������� ���������� ����������� ��������� � ������� ������.</returns>
    function GetWorldPosition(const APosition: TVectorF): TVectorF;
    ///<summary>����������� �������� ���������� �� ��� X � ����������.</summary>
    ///<param name="X">�������� ���������� ��������� ����� �� ��� X</param>
    ///<returns>���������� ���������� �� ��� X ����������� ��������� � ������� ������.</returns>
    function GetWorldX(X: Single): Single;
    ///<summary>����������� �������� ���������� �� ��� Y � ����������.</summary>
    ///<param name="Y">�������� ���������� ��������� ����� �� ��� Y</param>
    ///<returns>���������� ���������� �� ��� Y ����������� ��������� � ������� ������.</returns>
    function GetWorldY(Y: Single): Single;

    ///<summary>����������� �������� ������ � ����������.</summary>
    ///<param name="ASize">�������� ������ ��������� �������.</param>
    ///<returns>���������� ������ ����������� ������� ������.</returns>
    function GetWorldSize(const ASize: TVectorF): TVectorF;
    ///<summary>����������� �������� ������ � ����������.</summary>
    ///<param name="AWidth">�������� ������ ��������� �������.</param>
    ///<returns>���������� ������ ����������� ������� ������.</returns>
    function GetWorldWidth(AWidth: Single): Single;
    ///<summary>����������� �������� ������ � ����������.</summary>
    ///<param name="AHeight">�������� ����� ��������� �������.</param>
    ///<returns>���������� ������ ����������� ������� ������.</returns>
    function GetWorldHeight(AHeight: Single): Single;

    ///<summary>������� ������, ��������������� ������ ������.</remarks>
    property Position: TVectorF read GetPosition write SetPosition;
    ///<summary>������� ������, ��������������� ������ �������� ���� ������.</remarks>
    property LeftTopPosition: TVectorF read GetLeftTopPosition write SetLeftTopPosition;
    ///<summary>����������� ���������� ���������� � ��������.</summary>
    ///<param name="APosition">���������� ���������� ��������� �����</param>
    ///<returns>�������� ���������� ����������� ��������� � ������� ������.</returns>
    property ScreenPosition[const APosition: TVectorF]: TVectorF read GetScreenPosition;
    ///<summary>����������� ���������� ������ � ��������.</summary>
    ///<param name="ASize">���������� ������ ��������� �������.</param>
    ///<returns>�������� ������ ����������� ������� ������.</returns>
    property ScreenSize[const ASize: TVectorF]: TVectorF read GetScreenSize;
    ///<summary>����������� �������� ���������� � ����������.</summary>
    ///<param name="APosition">�������� ���������� ��������� �����</param>
    ///<returns>���������� ���������� ����������� ��������� � ������� ������.</returns>
    property WorldPosition[const APosition: TVectorF]: TVectorF read GetWorldPosition;
    ///<summary>����������� �������� ������ � ����������.</summary>
    ///<param name="ASize">�������� ������ ��������� �������.</param>
    ///<returns>���������� ������ ����������� ������� ������.</returns>
    property WorldSize[const ASize: TVectorF]: TVectorF read GetWorldSize;
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
    property Correction: TVectorF read GetCorrection;
    ///<summary>����, ���������������, ����������� �� ��������� ����������
    /// ��� ���������.</summary>
    ///<seealso cref="QEngine.Camera|IQuadCamera.ResolutionCorrectin" />
    property UseCorrection: Boolean read GetUseCorrection write SetUseCorrection;
    ///<summary>������� ���������� ������, � ������� �������� ������.</summary>
    property Resolution: TVectorF read GetResolution;
    ///<summary>���������� ��-���������, ����� �������� ����������� � ������� ��� ���������.</summary>
    property DefaultResolution: TVectorF read GetDefaultResolution;
  end;

implementation

end.
