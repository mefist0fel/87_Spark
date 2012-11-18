program Project_87;

uses
  SysUtils,
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
  Project87.Types.GameObject in 'Project87\Types\Project87.Types.GameObject.pas',
  Project87.Hero in 'Project87\Objects\Project87.Hero.pas',
  Project87.Resources in 'Project87\Project87.Resources.pas',
  Project87.Scenes.IntroScene in 'Project87\Scenes\Project87.Scenes.IntroScene.pas',
  Project87.Scenes.MainMenuScene in 'Project87\Scenes\Project87.Scenes.MainMenuScene.pas',
  Project87.Asteroid in 'Project87\Objects\Project87.Asteroid.pas',
  uMain in 'uMain.pas',
  Strope.Utils in 'Strope\Strope.Utils.pas',
  Project87.Fluid in 'Project87\Objects\Project87.Fluid.pas',
  Project87.BaseEnemy in 'Project87\Objects\Project87.BaseEnemy.pas',
  Project87.Bullet in 'Project87\Objects\Project87.Bullet.pas',
  Project87.Types.Weapon in 'Project87\Types\Project87.Types.Weapon.pas',
  Project87.BaseUnit in 'Project87\Objects\Project87.BaseUnit.pas',
  Project87.BigEnemy in 'Project87\Objects\Project87.BigEnemy.pas',
  Project87.SmallEnemy in 'Project87\Objects\Project87.SmallEnemy.pas',
  Project87.ScannerWave in 'Project87\Objects\Project87.ScannerWave.pas',
  Project87.Scenes.StarMapScene in 'Project87\Scenes\Project87.Scenes.StarMapScene.pas',
  Project87.Types.StarMap in 'Project87\Types\Project87.Types.StarMap.pas',
  Project87.Types.SimpleGUI in 'Project87\Types\Project87.Types.SimpleGUI.pas',
  Project87.Types.SystemGenerator in 'Project87\Types\Project87.Types.SystemGenerator.pas',
  Project87.Types.StarFon in 'Project87\Types\Project87.Types.StarFon.pas',
  Project87.Types.HeroInterface in 'Project87\Types\Project87.Types.HeroInterface.pas',
  Project87.Rocket in 'Project87\Objects\Project87.Rocket.pas';

begin
//  ReportMemoryLeaksOnShutdown := True;
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
