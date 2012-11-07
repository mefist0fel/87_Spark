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

    function GetCenterPosition(): TVectorF;
    procedure SetCenterPosition(const APosition: TVectorF);

    function GetScale(): TVectorF;
    procedure SetScale(const AScale: TVectorF);

    function GetResolutionCorrection(): TVectorF;

    function GetIsUseCorrection(): Boolean;
    procedure SetIsUseCorrection(AIsUseCorrection: Boolean);

    ///<summary>Преобразует глобальные координаты в экранные.</summary>
    ///<param name="AWorldPosition">Глобальные координаты некоторой точки</param>
    ///<returns>Экранные координаты учитывающие положение и масштаб камеры.</returns>
    function GetScreenPosition(const AWorldPosition: TVectorF): TVectorF;
    ///<summary>Преобразует глобальную координату по оси X в экранную.</summary>
    ///<param name="AWorldX">Глобальная координата некоторой точки по оси X</param>
    ///<returns>Экранная координата по оси X учитывающие положение и масштаб камеры.</returns>
    function GetScreenX(AWorldX: Single): Single;
    ///<summary>Преобразует глобальную координату по оси Y в экранную.</summary>
    ///<param name="AWorldY">Глобальная координата некоторой точки по оси Y</param>
    ///<returns>Экранная координата по оси Y учитывающие положение и масштаб камеры.</returns>
    function GetScreenY(AWordlY: Single): Single;

    ///<summary>Преобразует глобальный размер в экранный.</summary>
    ///<param name="AWorldSize">Глобальные размер некоторой области.</param>
    ///<returns>Экранный размер учитывающие масштаб камеры.</returns>
    function GetScreenSize(const AWorldSize: TVectorF): TVectorF;
    ///<summary>Преобразует глобальную ширину в экранную.</summary>
    ///<param name="AWorldWidth">Глобальная ширина некоторой области.</param>
    ///<returns>Экранная ширина учитывающая масштаб камеры.</returns>
    function GetScreenWidth(AWorldWidth: Single): Single;
    ///<summary>Преобразует глобальную высоту в экранную.</summary>
    ///<param name="AWorldHeight">Глобальная высота некоторой области.</param>
    ///<returns>Экранная высота учитывающая масштаб камеры.</returns>
    function GetScreenHeight(AWorldHeight: Single): Single;

    ///<summary>Преобразует экранные координаты в глобальные.</summary>
    ///<param name="ASreenPosition">Экранные координаты некоторой точки</param>
    ///<returns>Глобальные координаты учитывающие положение и масштаб камеры.</returns>
    function GetWorldPosition(const AScreenPosition: TVectorF): TVectorF;
    ///<summary>Преобразует экранную координату по оси X в глобальную.</summary>
    ///<param name="AScreenX">Экранная координата некоторой точки по оси X</param>
    ///<returns>Глобальная координата по оси X учитывающие положение и масштаб камеры.</returns>
    function GetWorldX(ASreenX: Single): Single;
    ///<summary>Преобразует экранную координату по оси Y в глобальную.</summary>
    ///<param name="AScreenY">Экранная координата некоторой точки по оси Y</param>
    ///<returns>Глобальная координата по оси Y учитывающие положение и масштаб камеры.</returns>
    function GetWorldY(AScrenY: Single): Single;

    ///<summary>Преобразует экранный размер в глобальный.</summary>
    ///<param name="AScreenSize">Экранный размер некоторой области.</param>
    ///<returns>Глобальный размер учитывающие масштаб камеры.</returns>
    function GetWorldSize(const AScreenSize: TVectorF): TVectorF;
    ///<summary>Преобразует экранную ширину в глобальную.</summary>
    ///<param name="AWorldWidth">Экранная ширина некоторой области.</param>
    ///<returns>Глобальная ширина учитывающая масштаб камеры.</returns>
    function GetWorldWidth(AScreenWidth: Single): Single;
    ///<summary>Преобразует экранную высоту в глобальную.</summary>
    ///<param name="AWorldHeight">Экранная высоа некоторой области.</param>
    ///<returns>Глобальная высота учитывающая масштаб камеры.</returns>
    function GetWorldHeight(AScreenHeight: Single): Single;

    ///<summary>Позиция камеры.</summary>
    ///<remarks>Позиция камеры соответствует левому верхнему краю экрана.</remarks>
    property Position: TVectorF read GetPosition write SetPosition;
    property CenterPosition: TVectorF read GetCenterPosition write SetCenterPosition;
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
    property ResolutionCorrection: TVectorF read GetResolutionCorrection;
    ///<summary>Флаг, устанавливающий, учитывается ли коррекция разрешения
    /// при отрисовке.</summary>
    ///<seealso cref="QEngine.Camera|IQuadCamera.ResolutionCorrectin" />
    property IsUseCorrection: Boolean read GetIsUseCorrection write SetIsUseCorrection;
  end;

implementation

end.
