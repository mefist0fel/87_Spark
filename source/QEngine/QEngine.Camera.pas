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

    function GetScale(): TVectorF;
    procedure SetScale(const AScale: TVectorF);

    function GetUseCorrection(): Boolean;
    procedure SetUseCorrection(AUseCorrection: Boolean);

    function GetResolution(): TVectorF;
    function GetDefaultResolution(): TVectorF;

    ///<summary>����������� ���������� ���������� � ��������.</summary>
    ///<param name="APosition">���������� ���������� ��������� �����</param>
    ///<param name="AIsUseCorrection">����, ���������� �� ��, ����� �� ���������� ���������
    /// ���������� ��� ������� ���������.</param>
    ///<returns>�������� ���������� ����������� ��������� � ������� ������.</returns>
    ///<remarks>��������� ����� AIsUseCorrection �������� � ����, ��� �����
    /// ������������ ���������� �� ������ �� ���������, �� ���� ��� �������������� ������
    /// ���������� � ������������� �������� ������. </remarks>
    function GetScreenPos(const APosition: TVectorF; AIsUseCorrection: Boolean = True): TVectorF;

    ///<summary>����������� ���������� ������ � ��������.</summary>
    ///<param name="ASize">���������� ������ ��������� �������.</param>
    ///<param name="AIsUseCorrection">����, ���������� �� ��, ����� �� ���������� ���������
    /// ���������� ��� ������� ���������.</param>
    ///<returns>�������� ������ ����������� ������� ������.</returns>
    function GetScreenSize(const ASize: TVectorF; AIsUseCorrection: Boolean = True): TVectorF;

    ///<summary>����������� �������� ���������� � ����������.</summary>
    ///<param name="APosition">�������� ���������� ��������� �����</param>
    ///<param name="AIsUseCorrection">����, ���������� �� ��, ����� �� ���������� ���������
    /// ���������� ��� ������� ���������.</param>
    ///<returns>���������� ���������� ����������� ��������� � ������� ������.</returns>
    ///<remarks>��������� ����� AIsUseCorrection �������� � ����, ��� �����
    /// ������������ ���������� ���������� ����� �� ������ �� ���������,
    /// �� ���� ����� (0, 0) ������ �� ��������� �� ����������� ����� ���������������
    /// ����� (0, 0) �������� ������, ��� ����� ����������� ���, ��� ���������
    /// ����� ������� ���� �������������� ���������� �� ���������
    /// ���������� � ������������� �������� ������. </remarks>
    function GetWorldPos(const APosition: TVectorF; AIsUseCorrection: Boolean = True): TVectorF;

    ///<summary>����������� �������� ������ � ����������.</summary>
    ///<param name="ASize">�������� ������ ��������� �������.</param>
    ///<param name="AIsUseCorrection">����, ���������� �� ��, ����� �� ���������� ���������
    /// ���������� ��� ������� ���������.</param>
    ///<returns>���������� ������ ����������� ������� ������.</returns>
    function GetWorldSize(const ASize: TVectorF; AIsUseCorrection: Boolean = True): TVectorF;

    ///<summary>������� ������, ��������������� ������ ������.</remarks>
    property Position: TVectorF read GetPosition write SetPosition;
    ///<summary>���������� ����������� ������ �� ����.</summary>
    ///<remarks>��� ������� ������������� �������� �������� ��� ������� �� ������.</remarks>
    property Scale: TVectorF read GetScale write SetScale;
    ///<summary>����, ���������������, ����������� �� ��������� ����������
    /// ��� ���������.</summary>
    property UseCorrection: Boolean read GetUseCorrection write SetUseCorrection;
    ///<summary>������� ���������� ������, � ������� �������� ������.</summary>
    property Resolution: TVectorF read GetResolution;
    ///<summary>���������� ��-���������, ����� �������� ����������� � ������� ��� ���������.</summary>
    property DefaultResolution: TVectorF read GetDefaultResolution;
  end;

implementation

end.
