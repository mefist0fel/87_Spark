unit QGame.SceneManager;

interface

uses
  Generics.Collections,
  QCore.Types,
  QCore.Input,
  QGame.Scene,
  Strope.Math;

type
  TSceneManager = class sealed (TComponent)
    strict private
      FScenes: TDictionary<string, TScene>;
      FCurrentScene: TScene;

      function GetScene(const ASceneName: string): TScene;
    public
      constructor Create;
      destructor Destroy; override;

      procedure AddScene(AScene: TScene);
      procedure MakeCurrent(const ASceneName: string);
      procedure DeleteScene(const ASceneName: string);

      ///<summary>Метод вызывается для инициализации текущей сцены.</summary>
      ///<param name="AParameter">Объект-параметр для инициализации.</param>
      procedure OnInitialize(AParameter: TObject = nil); override;

      ///<summary>Метод служит для активации или деактивации текущей сцены.</summary>
      ///<param name="AIsActivate">Значение True служит для активации,
      ///значение False - для деактивации.</param>
      procedure OnActivate(AIsActivate: Boolean); override;

      ///<summary>Метод вызывается для отрисовки текущей сцены.</summary>
      ///<param name="ALayer">Слой сцены для отрисовки.</param>
      procedure OnDraw(const ALayer: Integer); override;

      ///<summary>Метод вызывается для обновления состояния текущей сцены.</summary>
      ///<param name="ADelta">Промежуток времены в секундах,
      ///прошедший с предыдущего обновления состояния.</param>
      procedure OnUpdate(const ADelta: Double); override;

      ///<summary>Метод должен вызываться (вручную или в деструкторе) для или перед удалением текущей сцены.
      /// Служит для очистки занятых сценой ресурсов.</summary>
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
    public
  end;

implementation

uses
  SysUtils;

{$REGION '  TSceneManager  '}
constructor TSceneManager.Create;
begin
  FScenes := TDictionary<string, TScene>.Create;
  FCurrentScene := nil;
end;

destructor TSceneManager.Destroy;
var
  AScene: TScene;
begin
  for AScene in FScenes.Values do
  begin
    AScene.OnDestroy;
    AScene.Free;
  end;
  FScenes.Free;

  inherited;
end;

function TSceneManager.GetScene(const ASceneName: string): TScene;
begin
  Result := nil;
  FScenes.TryGetValue(AnsiUpperCase(ASceneName), Result);
end;

procedure TSceneManager.AddScene(AScene: TScene);
begin
  if Assigned(AScene) then
  begin
    if Assigned(GetScene(AScene.Name)) then
      raise EArgumentException.Create(
        'Сцена с таким именем уже существует. ' +
        '{0CAED87C-8402-47EA-A245-4BAA77905A23}');

    FScenes.Add(AScene.Name, AScene);
  end;
end;

procedure TSceneManager.MakeCurrent(const ASceneName: string);
begin
  FCurrentScene := GetScene(ASceneName);
end;

procedure TSceneManager.DeleteScene(const ASceneName: string);
var
  AScene: TScene;
begin
  AScene := GetScene(ASceneName);
  if Assigned(AScene) then
  begin
    if FCurrentScene = AScene then
      FCurrentScene := nil;
    FScenes.Remove(AScene.Name);
    AScene.OnDestroy;
    FreeAndNil(AScene);
  end;
end;

procedure TSceneManager.OnActivate(AIsActivate: Boolean);
begin
  if Assigned(FCurrentScene) then
    FCurrentScene.OnActivate(AIsActivate);
end;

procedure TSceneManager.OnDestroy;
begin
  if Assigned(FCurrentScene) then
    FCurrentScene.OnDestroy;
end;

procedure TSceneManager.OnDraw(const ALayer: Integer);
begin
  if Assigned(FCurrentScene) then
    FCurrentScene.OnDraw(ALayer);
end;

procedure TSceneManager.OnInitialize(AParameter: TObject);
begin
  if Assigned(FCurrentScene) then
    FCurrentScene.OnInitialize(AParameter);
end;

function TSceneManager.OnKeyDown(AKey: TKeyButton): Boolean;
begin
  Result := True;
  if Assigned(FCurrentScene) then
    Result := FCurrentScene.OnKeyDown(AKey);
end;

function TSceneManager.OnKeyUp(AKey: TKeyButton): Boolean;
begin
  Result := True;
  if Assigned(FCurrentScene) then
    Result := FCurrentScene.OnKeyUp(AKey);
end;

function TSceneManager.OnMouseButtonDown(AButton: TMouseButton;
  const AMousePosition: TVectorF): Boolean;
begin
  Result := True;
  if Assigned(FCurrentScene) then
    Result := FCurrentScene.OnMouseButtonDown(AButton, AMousePosition);
end;

function TSceneManager.OnMouseButtonUp(AButton: TMouseButton;
  const AMousePosition: TVectorF): Boolean;
begin
  Result := True;
  if Assigned(FCurrentScene) then
    Result := FCurrentScene.OnMouseButtonUp(AButton, AMousePosition);
end;

function TSceneManager.OnMouseMove(const AMousePosition: TVectorF): Boolean;
begin
  Result := True;
  if Assigned(FCurrentScene) then
    Result := FCurrentScene.OnMouseMove(AMousePosition);
end;

function TSceneManager.OnMouseWheel(ADirection: Integer;
  const AMousePosition: TVectorF): Boolean;
begin
  Result := True;
  if Assigned(FCurrentScene) then
    Result := FCurrentScene.OnMouseWheel(ADirection, AMousePosition)
end;

procedure TSceneManager.OnUpdate(const ADelta: Double);
begin
  if Assigned(FCurrentScene) then
    FCurrentScene.OnUpdate(ADelta);
end;

end.
