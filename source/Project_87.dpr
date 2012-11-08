program Project_87;

{$DEFINE AUTOREFCOUNT}

uses
  SysUtils,
  uMain in 'uMain.pas',
  Strope.Math in 'Strope\Strope.Math.pas',
  QGame.Game in 'QGame\QGame.Game.pas',
  QGame.ResourceManager in 'QGame\QGame.ResourceManager.pas',
  QGame.SceneManager in 'QGame\QGame.SceneManager.pas',
  D3DX9 in 'QEngine\Engine\D3DX9.pas',
  direct3d9 in 'QEngine\Engine\direct3d9.pas',
  DXTypes in 'QEngine\Engine\DXTypes.pas',
  QuadEngine in 'QEngine\Engine\QuadEngine.pas',
  QApplication.Application in 'QApplication\QApplication.Application.pas',
  QEngine.Camera in 'QEngine\QEngine.Camera.pas',
  QEngine.Device in 'QEngine\QEngine.Device.pas',
  QEngine.Font in 'QEngine\QEngine.Font.pas',
  QEngine.Render in 'QEngine\QEngine.Render.pas',
  QEngine.Texture in 'QEngine\QEngine.Texture.pas',
  QApplication.Window in 'QApplication\QApplication.Window.pas',
  QCore.Types in 'QCore\QCore.Types.pas',
  QCore.Input in 'QCore\QCore.Input.pas',
  QEngine.Core in 'QEngine\QEngine.Core.pas',
  QEngine.Types in 'QEngine\QEngine.Types.pas',
  QGame.Scene in 'QGame\QGame.Scene.pas',
  Project87.Game in 'Project87\Project87.Game.pas',
  QGame.Resources in 'QGame\QGame.Resources.pas',
  Project87.Scenes.TestScene in 'Project87\Scenes\Project87.Scenes.TestScene.pas',
  Project87.Scenes.Game in 'Project87\Scenes\Project87.Scenes.Game.pas',
  QApplication.Input in 'QApplication\QApplication.Input.pas',
  Project87.GameObject in 'Project87\Project87.GameObject.pas',
  Project87.Hero in 'Project87\Objects\Project87.Hero.pas',
  Project87.Resources in 'Project87\Project87.Resources.pas',
  Project87.Scenes.IntroScene in 'Project87\Scenes\Project87.Scenes.IntroScene.pas',
  Project87.Scenes.MainMenuScene in 'Project87\Scenes\Project87.Scenes.MainMenuScene.pas';

begin
  //ReportMemoryLeaksOnShutdown := True;
  try
    try
      InitializeApplication;
      StartApplication;
    except
      on E: Exception do
        Writeln(E.ClassName, ': ', E.Message);
    end;
  finally
    DestroyApplication;
  end;
end.
