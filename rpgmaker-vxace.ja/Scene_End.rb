#
# ゲーム終了画面の処理を行うクラスです。
#

class Scene_End < Scene_MenuBase
  #
  # 開始処理
  #
  #
  def start
    super
    create_command_window
  end
  #
  # 終了前処理
  #
  #
  def pre_terminate
    super
    close_command_window
  end
  #
  # 背景の作成
  #
  #
  def create_background
    super
    @background_sprite.tone.set(0, 0, 0, 128)
  end
  #
  # コマンドウィンドウの作成
  #
  #
  def create_command_window
    @command_window = Window_GameEnd.new
    @command_window.set_handler(:to_title, method(:command_to_title))
    @command_window.set_handler(:shutdown, method(:command_shutdown))
    @command_window.set_handler(:cancel,   method(:return_scene))
  end
  #
  # コマンドウィンドウを閉じる
  #
  #
  def close_command_window
    @command_window.close
    update until @command_window.close?
  end
  #
  # コマンド［タイトルへ］
  #
  #
  def command_to_title
    close_command_window
    fadeout_all
    SceneManager.goto(Scene_Title)
  end
  #
  # コマンド［シャットダウン］
  #
  #
  def command_shutdown
    close_command_window
    fadeout_all
    SceneManager.exit
  end
end
