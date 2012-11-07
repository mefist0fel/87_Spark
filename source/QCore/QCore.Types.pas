unit QCore.Types;

interface

uses
  QuadEngine,
  QCore.Input,
  Strope.Math;

type
  ///<summary>Базовый тип для индефикаторов объектов.</summary>
  TObjectId = Cardinal;

  ///<summary>Базовый класс для всех игровых классов,
  /// реализующих какие-либо интерфейсы.</summary>
  TBaseObject = class abstract (TInterfacedObject)
  end;

  ///<summary>Базовый интерфейс для объектов,
  /// определяющий методы для реакции на основные события</summary>
  IBaseActions = interface (IUnknown)
    ///<summary>Метод вызывается для инициализации объекта.</summary>
    ///<param name="AParameter">Объект-параметр для инициализации.</param>
    procedure OnInitialize(AParameter: TObject = nil);

    ///<summary>Метод служит для активации или деактивации объекта.</summary>
    ///<param name="AIsActivate">Значение True служит для активации объекта,
    ///значение False - для деактивации.</param>
    procedure OnActivate(AIsActivate: Boolean);

    ///<summary>Метод вызывается для отрисовки объекта.</summary>
    ///<param name="ALayer">Слой объекта для отрисовки.</param>
    procedure OnDraw(const ALayer: Integer);

    ///<summary>Метод вызывается для обновления состояния объекта.</summary>
    ///<param name="ADelta">Промежуток времены в секундах,
    ///прошедший с предыдущего обновления состояния.</param>
    procedure OnUpdate(const ADelta: Double);

    ///<summary>Метод должен вызываться (вручную или в деструкторе) для или перед удалением объекта.
    /// Служит для очистки занятых объектом ресурсов.</summary>
    procedure OnDestroy;
  end;

  ///<summary>Базовый интерфейс для объектов,
  /// определяющий методы для реакции на события ввода-вывода.</summary>
  IInputActions = interface (IUnknown)
    ///<summary>Метод вызывается для реакции на событие "движение мышки"</summary>
    ///<param name="AMousePosition">Текущие координаты мыши,
    ///относительно левого верхнего края рабочего окна.</param>
    ///<returns>Возвращенное логическое значение сигнализирует о том,
    ///было ли событие обработано объектом.</returns>
    function OnMouseMove(const AMousePosition: TVectorF): Boolean;

    ///<summary>Метод вызывается для реакции на событие <b><i>нажатие кнопки мыши</i></b></summary>
    ///<param name="AButton">Нажатая кнопка мыши.</param>
    ///<param name="AMousePosition">Координаты мыши в момент нажатие кнопки,
    ///относительно левого верхнего края рабочего окна.</param>
    ///<returns>Возвращенное логическое значение сигнализирует о том,
    ///было ли событие обработано объектом.</returns>
    ///<remarks>Значения перечисления <see creg="QCore.Input|TMouseButton" />
    /// можно узать в модуле QCore.Input.</remarks>
    function OnMouseButtonDown(
      AButton: TMouseButton; const AMousePosition: TVectorF): Boolean;

    ///<summary>Метод вызывается для реакции на событие <b><i>отпускание кнопки мыши</i></b></summary>
    ///<param name="AButton">Отпущенная кнопка мыши.</param>
    ///<param name="AMousePosition">Координаты мыши в момент отпускания кнопки,
    /// относительно левого верхнего края рабочего окна.</param>
    ///<returns>Возвращенное логическое значение сигнализирует о том,
    ///было ли событие обработано объектом.</returns>
    ///<remarks>Значения перечисления <see creg="QCore.Input|TMouseButton" />
    /// можно узать в модуле QCore.Input.</remarks>
    function OnMouseButtonUp(
      AButton: TMouseButton; const AMousePosition: TVectorF): Boolean;

    ///<summary>Метод вызывается для реакции на событие <b><i>прокрутка колеса мыши вниз</i></b></summary>
    ///<param name="ADirection">Напревление прокрутки колеса.
    /// Значение +1 соответствует прокрутке вверх, -1 - вниз.</param>
    ///<param name="AMousePosition">Координаты мыши в момент прокрутки колеса,
    /// относительно левого верхнего края рабочего окна.</param>
    ///<returns>Возвращенное логическое значение сигнализирует о том,
    ///было ли событие обработано объектом.</returns>
    function OnMouseWheel(ADirection: Integer; const AMousePosition: TVectorF): Boolean;

    ///<summary>Метод вызывается для рекции на событие <b><i>нажатие кнопки на клавиатуре</i></b></summary>
    ///<param name="AKey">Нажатая кнопка на клавиатуре.</param>
    ///<returns>Возвращенное логическое значение сигнализирует о том,
    ///было ли событие обработано объектом.</returns>
    ///<remarks>Значения констант TKeyButton можно узать в модуле uInput.</remarks>
    function OnKeyDown(AKey: TKeyButton): Boolean;

    ///<summary>Метод вызывается для рекции на событие <b><i>отпускание кнопки на клавиатуре</i></b></summary>
    ///<param name="AKey">Отпущенная кнопка на клавиатуре.</param>
    ///<returns>Возвращенное логическое значение сигнализирует о том,
    ///было ли событие обработано объектом.</returns>
    ///<remarks>Значения констант TKeyButton можно узать в модуле uInput.</remarks>
    function OnKeyUp(AKey: TKeyButton): Boolean;
  end;

  ///<summary>Базовый тип для объектов,
  /// способных реагировать на основные событя и события ввода-вывода.</summary>
  TComponent = class abstract (TBaseObject, IBaseActions, IInputActions)
    public
      ///<summary>Метод вызывается для инициализации объекта.</summary>
      ///<param name="AParameter">Объект-параметр для инициализации.</param>
      procedure OnInitialize(AParameter: TObject = nil); virtual; abstract;

      ///<summary>Метод служит для активации или деактивации объекта.</summary>
      ///<param name="AIsActivate">Значение True служит для активации объекта,
      ///значение False - для деактивации.</param>
      procedure OnActivate(AIsActivate: Boolean); virtual; abstract;

      ///<summary>Метод вызывается для отрисовки объекта.</summary>
      ///<param name="ALayer">Слой объекта для отрисовки.</param>
      procedure OnDraw(const ALayer: Integer); virtual; abstract;

      ///<summary>Метод вызывается для обновления состояния объекта.</summary>
      ///<param name="ADelta">Промежуток времены в секундах,
      ///прошедший с предыдущего обновления состояния.</param>
      procedure OnUpdate(const ADelta: Double); virtual; abstract;

      ///<summary>Метод должен вызываться (вручную или в деструкторе) для или перед удалением объекта.
      /// Служит для очистки занятых объектом ресурсов.</summary>
      procedure OnDestroy; virtual; abstract;

      ///<summary>Метод вызывается для реакции на событие "движение мышки"</summary>
      ///<param name="AMousePosition">Текущие координаты мыши,
      ///относительно левого верхнего края рабочего окна.</param>
      ///<returns>Возвращенное логическое значение сигнализирует о том,
      ///было ли событие обработано объектом.</returns>
      function OnMouseMove(const AMousePosition: TVectorF): Boolean; virtual; abstract;

      ///<summary>Метод вызывается для реакции на событие <b><i>нажатие кнопки мыши</i></b></summary>
      ///<param name="AButton">Нажатая кнопка мыши.</param>
      ///<param name="AMousePosition">Координаты мыши в момент нажатие кнопки,
      ///относительно левого верхнего края рабочего окна.</param>
      ///<returns>Возвращенное логическое значение сигнализирует о том,
      ///было ли событие обработано объектом.</returns>
      ///<remarks>Значения перечисления <see creg="QCore.Input|TMouseButton" />
      /// можно узать в модуле QCore.Input.</remarks>
      function OnMouseButtonDown(
        AButton: TMouseButton; const AMousePosition: TVectorF): Boolean; virtual; abstract;

      ///<summary>Метод вызывается для реакции на событие <b><i>отпускание кнопки мыши</i></b></summary>
      ///<param name="AButton">Отпущенная кнопка мыши.</param>
      ///<param name="AMousePosition">Координаты мыши в момент отпускания кнопки,
      /// относительно левого верхнего края рабочего окна.</param>
      ///<returns>Возвращенное логическое значение сигнализирует о том,
      ///было ли событие обработано объектом.</returns>
      ///<remarks>Значения перечисления <see creg="QCore.Input|TMouseButton" />
      /// можно узать в модуле QCore.Input.</remarks>
      function OnMouseButtonUp(
        AButton: TMouseButton; const AMousePosition: TVectorF): Boolean; virtual; abstract;

      ///<summary>Метод вызывается для реакции на событие <b><i>прокрутка колеса мыши вниз</i></b></summary>
      ///<param name="ADirection">Напревление прокрутки колеса.
      /// Значение +1 соответствует прокрутке вверх, -1 - вниз.</param>
      ///<param name="AMousePosition">Координаты мыши в момент прокрутки колеса,
      /// относительно левого верхнего края рабочего окна.</param>
      ///<returns>Возвращенное логическое значение сигнализирует о том,
      ///было ли событие обработано объектом.</returns>
      function OnMouseWheel(ADirection: Integer;
        const AMousePosition: TVectorF): Boolean; virtual; abstract;

      ///<summary>Метод вызывается для рекции на событие <b><i>нажатие кнопки на клавиатуре</i></b></summary>
      ///<param name="AKey">Нажатая кнопка на клавиатуре.</param>
      ///<returns>Возвращенное логическое значение сигнализирует о том,
      ///было ли событие обработано объектом.</returns>
      ///<remarks>Значения констант TKeyButton можно узать в модуле uInput.</remarks>
      function OnKeyDown(AKey: TKeyButton): Boolean; virtual; abstract;

      ///<summary>Метод вызывается для рекции на событие <b><i>отпускание кнопки на клавиатуре</i></b></summary>
      ///<param name="AKey">Отпущенная кнопка на клавиатуре.</param>
      ///<returns>Возвращенное логическое значение сигнализирует о том,
      ///было ли событие обработано объектом.</returns>
      ///<remarks>Значения констант TKeyButton можно узать в модуле uInput.</remarks>
      function OnKeyUp(AKey: TKeyButton): Boolean; virtual; abstract;
  end;

implementation

end.

