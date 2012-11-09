unit QEngine.Camera;

interface

uses
  Strope.Math;

type
  ///<summary>Интерфейс предоставляющий возможность установки параметров камеры
  /// а также возможность перевода глобальных размеров и позиций в экранные
  /// и наоборот</summary>
  IQuadCamera = interface (IUnknown)
    function GetPosition(): TVectorF;
    procedure SetPosition(const APosition: TVectorF);

    function GetScale(): TVectorF;
    procedure SetScale(const AScale: TVectorF);

    function GetUseCorrection(): Boolean;
    procedure SetUseCorrection(AUseCorrection: Boolean);

    function GetResolution(): TVectorF;
    function GetDefaultResolution(): TVectorF;

    ///<summary>Преобразует глобальные координаты в экранные.</summary>
    ///<param name="APosition">Глобальные координаты некоторой точки</param>
    ///<param name="AIsUseCorrection">Флаг, указвающий на то, будет ли учитыватся коррекция
    /// разрешения при расчёте координат.</param>
    ///<returns>Экранные координаты учитывающие положение и масштаб камеры.</returns>
    ///<remarks>Установка флага AIsUseCorrection приводит к тому, что будут
    /// возвращаться координаты на экране по умолчанию, то есть для прямоугольника экрана
    /// вписанного в прямоугольник текущего экрана. </remarks>
    function GetScreenPos(const APosition: TVectorF; AIsUseCorrection: Boolean = True): TVectorF;

    ///<summary>Преобразует глобальный размер в экранный.</summary>
    ///<param name="ASize">Глобальные размер некоторой области.</param>
    ///<param name="AIsUseCorrection">Флаг, указвающий на то, будет ли учитыватся коррекция
    /// разрешения при расчёте координат.</param>
    ///<returns>Экранный размер учитывающие масштаб камеры.</returns>
    function GetScreenSize(const ASize: TVectorF; AIsUseCorrection: Boolean = True): TVectorF;

    ///<summary>Преобразует экранные координаты в глобальные.</summary>
    ///<param name="APosition">Экранные координаты некоторой точки</param>
    ///<param name="AIsUseCorrection">Флаг, указвающий на то, будет ли учитыватся коррекция
    /// разрешения при расчёте координат.</param>
    ///<returns>Глобальные координаты учитывающие положение и масштаб камеры.</returns>
    ///<remarks>Установка флага AIsUseCorrection приводит к тому, что будут
    /// возвращаться глобальные координаты точки на экране по умолчанию,
    /// то есть точка (0, 0) экрана по умолчанию не обязательно будет соответсвтовать
    /// точке (0, 0) текущего экрана, она будет расположена там, где находится
    /// левый верхний угол прямоугольника разрешения по умолчанию
    /// вписанного в прямоугольник текущего экрана. </remarks>
    function GetWorldPos(const APosition: TVectorF; AIsUseCorrection: Boolean = True): TVectorF;

    ///<summary>Преобразует экранный размер в глобальный.</summary>
    ///<param name="ASize">Экранный размер некоторой области.</param>
    ///<param name="AIsUseCorrection">Флаг, указвающий на то, будет ли учитыватся коррекция
    /// разрешения при расчёте координат.</param>
    ///<returns>Глобальный размер учитывающий масштаб камеры.</returns>
    function GetWorldSize(const ASize: TVectorF; AIsUseCorrection: Boolean = True): TVectorF;

    ///<summary>Позиция камеры, соответствующая центру экрана.</remarks>
    property Position: TVectorF read GetPosition write SetPosition;
    ///<summary>Масштабный коэффициент камеры по осям.</summary>
    ///<remarks>При задании отрицательных значений масштаба они берутся по модулю.</remarks>
    property Scale: TVectorF read GetScale write SetScale;
    ///<summary>Флаг, устанавливающий, учитывается ли коррекция разрешения
    /// при отрисовке.</summary>
    property UseCorrection: Boolean read GetUseCorrection write SetUseCorrection;
    ///<summary>Текущее разрешение экрана, с которым работает камера.</summary>
    property Resolution: TVectorF read GetResolution;
    ///<summary>Разрешение по-умолчанию, экран которого вписывается в текущий при коррекции.</summary>
    property DefaultResolution: TVectorF read GetDefaultResolution;
  end;

implementation

end.
