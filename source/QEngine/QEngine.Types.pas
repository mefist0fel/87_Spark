unit QEngine.Types;

interface

uses
  QuadEngine,
  QEngine.Camera,
  Strope.Math;

type
  IQuadEngine = interface (IUnknown)
    function GetDevice(): IQuadDevice;
    function GetRender(): IQuadRender;

    function GetCamera(): IQuadCamera;
    procedure SetCamera(const ACamera: IQuadCamera);

    function GetDefaultResolution(): TVectorI;
    function GetCurrentResolution(): TVectorI;

    property QuadDevice: IQuadDevice read GetDevice;
    property QuadRender: IQuadRender read GetRender;
    property Camera: IQuadCamera read GetCamera write SetCamera;
    property DefaultResolution: TVectorI read GetDefaultResolution;
    property CurrentResolution: TVectorI read GetCurrentResolution;
  end;

implementation

end.
