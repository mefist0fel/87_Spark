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

      ///<summary>Метод вызывается для инициализации игры</summary>
      ///<param name="AParameter">Объект-параметр для инициализации.</param>
      procedure OnInitialize(AParameter: TObject = nil); override;

      ///<summary>Метод служит для установки режима паузы для игры.</summary>
      ///<param name="AIsActivate">Значение True служит для активации режима паузы,
      ///значение False - для деактивации.</param>
      ///<remarks>Режим паузы может не поддерживаться текущей игровой сценой,
      /// поэтому реакция вызов метода может отсутствовать.</remarks>
      procedure OnActivate(AIsActivate: Boolean); override;

      ///<summary>Метод вызывается для отрисовки текущей игровой сцены.</summary>
      ///<param name="ALayer">Слой сцены для отрисовки.</param>
      procedure OnDraw(const ALayer: Integer); override;

      ///<summary>Метод вызывается для обновления состояния игры.</summary>
      ///<param name="ADelta">Промежуток времены в секундах,
      ///прошедший с предыдущего обновления состояния.</param>
      procedure OnUpdate(const ADelta: Double); override;

      ///<summary>Метод должен вызываться (вручную или в деструкторе) для или перед удалением игры.
      /// Служит для очистки занятых игрой ресурсов.</summary>
      procedure OnDestroy; override;

      ///<summary>Метод вызывается для реакции на событие "движение мышки"</summary>
      ///<param name="AMousePosition">Текущие координаты мыши,
      ///относительно левого верхнего края рабочего окна.</param>
      ///<returns>Возвращенное логическое значение сигнализирует о том,
      ///было ли событие обработано объектом.</returns>
      function OnMouseMove(const AMousePosition: TVectorF): Boolean; override;

      ///<summary>Метод вызывается для реакции на событие <b><i>нажатие кнопки мыши</i></b></summary>
      ///<param name="AButton">Нажатая кнопка мыши.</param>
      ///<param name="AMousePosition">Координаты мыши в момент нажатие кнопки,
      ///относительно левого верхнего края рабочего окна.</param>
      ///<returns>Возвращенное логическое значение сигнализирует о том,
      ///было ли событие обработано объектом.</returns>
      ///<remarks>Значения перечисления <see creg="QCore.Input|TMouseButton" />
      /// можно узать в модуле QCore.Input.</remarks>
      function OnMouseButtonDown(
        AButton: TMouseButton; const AMousePosition: TVectorF): Boolean; override;

      ///<summary>Метод вызывается для реакции на событие <b><i>отпускание кнопки мыши</i></b></summary>
      ///<param name="AButton">Отпущенная кнопка мыши.</param>
      ///<param name="AMousePosition">Координаты мыши в момент отпускания кнопки,
      /// относительно левого верхнего края рабочего окна.</param>
      ///<returns>Возвращенное логическое значение сигнализирует о том,
      ///было ли событие обработано объектом.</returns>
      ///<remarks>Значения перечисления <see creg="QCore.Input|TMouseButton" />
      /// можно узать в модуле QCore.Input.</remarks>
      function OnMouseButtonUp(
        AButton: TMouseButton; const AMousePosition: TVectorF): Boolean; override;

      ///<summary>Метод вызывается для реакции на событие <b><i>прокрутка колеса мыши вниз</i></b></summary>
      ///<param name="ADirection">Напревление прокрутки колеса.
      /// Значение +1 соответствует прокрутке вверх, -1 - вниз.</param>
      ///<param name="AMousePosition">Координаты мыши в момент прокрутки колеса,
      /// относительно левого верхнего края рабочего окна.</param>
      ///<returns>Возвращенное логическое значение сигнализирует о том,
      ///было ли событие обработано объектом.</returns>
      function OnMouseWheel(ADirection: Integer;
        const AMousePosition: TVectorF): Boolean; override;

      ///<summary>Метод вызывается для рекции на событие <b><i>нажатие кнопки на клавиатуре</i></b></summary>
      ///<param name="AKey">Нажатая кнопка на клавиатуре.</param>
      ///<returns>Возвращенное логическое значение сигнализирует о том,
      ///было ли событие обработано объектом.</returns>
      ///<remarks>Значения констант TKeyButton можно узать в модуле uInput.</remarks>
      function OnKeyDown(AKey: TKeyButton): Boolean; override;

      ///<summary>Метод вызывается для рекции на событие <b><i>отпускание кнопки на клавиатуре</i></b></summary>
      ///<param name="AKey">Отпущенная кнопка на клавиатуре.</param>
      ///<returns>Возвращенное логическое значение сигнализирует о том,
      ///было ли событие обработано объектом.</returns>
      ///<remarks>Значения констант TKeyButton можно узать в модуле uInput.</remarks>
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

function TQGame.OnMouseWheel(ADirection: Integer;
  const AMousePosition: TVector2F): Boolean;
begin
  Result := SceneManager.OnMouseWheel(ADirection, AMousePosition);
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
