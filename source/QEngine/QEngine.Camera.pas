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

    function GetLeftTopPosition(): TVectorF;
    procedure SetLeftTopPosition(const APosition: TVectorF);

    function GetScale(): TVectorF;
    procedure SetScale(const AScale: TVectorF);

    function GetCorrection(): TVectorF;

    function GetUseCorrection(): Boolean;
    procedure SetUseCorrection(AUseCorrection: Boolean);

    function GetResolution(): TVectorF;
    function GetDefaultResolution(): TVectorF;

    ///<summary>Преобразует глобальные координаты в экранные.</summary>
    ///<param name="APosition">Глобальные координаты некоторой точки</param>
    ///<returns>Экранные координаты учитывающие положение и масштаб камеры.</returns>
    function GetScreenPosition(const APosition: TVectorF): TVectorF;
    ///<summary>Преобразует глобальную координату по оси X в экранную.</summary>
    ///<param name="X">Глобальная координата некоторой точки по оси X</param>
    ///<returns>Экранная координата по оси X учитывающие положение и масштаб камеры.</returns>
    function GetScreenX(X: Single): Single;
    ///<summary>Преобразует глобальную координату по оси Y в экранную.</summary>
    ///<param name="Y">Глобальная координата некоторой точки по оси Y</param>
    ///<returns>Экранная координата по оси Y учитывающие положение и масштаб камеры.</returns>
    function GetScreenY(Y: Single): Single;

    ///<summary>Преобразует глобальный размер в экранный.</summary>
    ///<param name="ASize">Глобальные размер некоторой области.</param>
    ///<returns>Экранный размер учитывающие масштаб камеры.</returns>
    function GetScreenSize(const ASize: TVectorF): TVectorF;
    ///<summary>Преобразует глобальную ширину в экранную.</summary>
    ///<param name="AWidth">Глобальная ширина некоторой области.</param>
    ///<returns>Экранная ширина учитывающая масштаб камеры.</returns>
    function GetScreenWidth(AWidth: Single): Single;
    ///<summary>Преобразует глобальную высоту в экранную.</summary>
    ///<param name="AHeight">Глобальная высота некоторой области.</param>
    ///<returns>Экранная высота учитывающая масштаб камеры.</returns>
    function GetScreenHeight(AHeight: Single): Single;

    ///<summary>Преобразует экранные координаты в глобальные.</summary>
    ///<param name="APosition">Экранные координаты некоторой точки</param>
    ///<returns>Глобальные координаты учитывающие положение и масштаб камеры.</returns>
    function GetWorldPosition(const APosition: TVectorF): TVectorF;
    ///<summary>Преобразует экранную координату по оси X в глобальную.</summary>
    ///<param name="X">Экранная координата некоторой точки по оси X</param>
    ///<returns>Глобальная координата по оси X учитывающие положение и масштаб камеры.</returns>
    function GetWorldX(X: Single): Single;
    ///<summary>Преобразует экранную координату по оси Y в глобальную.</summary>
    ///<param name="Y">Экранная координата некоторой точки по оси Y</param>
    ///<returns>Глобальная координата по оси Y учитывающие положение и масштаб камеры.</returns>
    function GetWorldY(Y: Single): Single;

    ///<summary>Преобразует экранный размер в глобальный.</summary>
    ///<param name="ASize">Экранный размер некоторой области.</param>
    ///<returns>Глобальный размер учитывающий масштаб камеры.</returns>
    function GetWorldSize(const ASize: TVectorF): TVectorF;
    ///<summary>Преобразует экранную ширину в глобальную.</summary>
    ///<param name="AWidth">Экранная ширина некоторой области.</param>
    ///<returns>Глобальная ширина учитывающая масштаб камеры.</returns>
    function GetWorldWidth(AWidth: Single): Single;
    ///<summary>Преобразует экранную высоту в глобальную.</summary>
    ///<param name="AHeight">Экранная высоа некоторой области.</param>
    ///<returns>Глобальная высота учитывающая масштаб камеры.</returns>
    function GetWorldHeight(AHeight: Single): Single;

    ///<summary>Позиция камеры, соответствующая центру экрана.</remarks>
    property Position: TVectorF read GetPosition write SetPosition;
    ///<summary>Позиция камеры, соответствующая левому верхнему краю экрана.</remarks>
    property LeftTopPosition: TVectorF read GetLeftTopPosition write SetLeftTopPosition;
    ///<summary>Преобразует глобальные координаты в экранные.</summary>
    ///<param name="APosition">Глобальные координаты некоторой точки</param>
    ///<returns>Экранные координаты учитывающие положение и масштаб камеры.</returns>
    property ScreenPosition[const APosition: TVectorF]: TVectorF read GetScreenPosition;
    ///<summary>Преобразует глобальный размер в экранный.</summary>
    ///<param name="ASize">Глобальные размер некоторой области.</param>
    ///<returns>Экранный размер учитывающие масштаб камеры.</returns>
    property ScreenSize[const ASize: TVectorF]: TVectorF read GetScreenSize;
    ///<summary>Преобразует экранные координаты в глобальные.</summary>
    ///<param name="APosition">Экранные координаты некоторой точки</param>
    ///<returns>Глобальные координаты учитывающие положение и масштаб камеры.</returns>
    property WorldPosition[const APosition: TVectorF]: TVectorF read GetWorldPosition;
    ///<summary>Преобразует экранный размер в глобальный.</summary>
    ///<param name="ASize">Экранный размер некоторой области.</param>
    ///<returns>Глобальный размер учитывающий масштаб камеры.</returns>
    property WorldSize[const ASize: TVectorF]: TVectorF read GetWorldSize;
    ///<summary>Масштабный коэффициент камеры по осям.</summary>
    ///<remarks>При задании отрицательных значений масштаба они берутся по модулю.</remarks>
    property Scale: TVectorF read GetScale write SetScale;
    ///<summary>Коэффициент коррекции разрешения. Показывает во сколько раз
    /// экран по умолчанию должен быть меньше или больше, что бы вписаться
    /// в текущий экран.</summary>
    ///<remarks>Коррекция по умолчанию включена, однако может потребоваться ручное
    /// её отключение и прямое использование коэффициента коррекции, так как
    /// она вызывает смещение экранных координат от указаных даже в случае
    /// задания масштабного коэффициента равного (1, 1). Это может
    /// создавать проблемы, например, при отрисовке интерфейса или
    /// других строго ориентированных относительно экрана элементов,
    /// которые вместе с тем должны иметь одинаковые относительные размеры относительно
    /// различных разрешений экрана.</remarks>
    property Correction: TVectorF read GetCorrection;
    ///<summary>Флаг, устанавливающий, учитывается ли коррекция разрешения
    /// при отрисовке.</summary>
    ///<seealso cref="QEngine.Camera|IQuadCamera.ResolutionCorrectin" />
    property UseCorrection: Boolean read GetUseCorrection write SetUseCorrection;
    ///<summary>Текущее разрешение экрана, с которым работает камера.</summary>
    property Resolution: TVectorF read GetResolution;
    ///<summary>Разрешение по-умолчанию, экран которого вписывается в текущий при коррекции.</summary>
    property DefaultResolution: TVectorF read GetDefaultResolution;
  end;

implementation

end.
