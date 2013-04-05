#
# ロード画面の処理を行うクラスです。
#

class Scene_Load < Scene_File
  #
  # ヘルプウィンドウのテキストを取得
  #
  #
  def help_window_text
    Vocab::LoadMessage
  end
  #
  # 最初に選択状態にするファイルインデックスを取得
  #
  #
  def first_savefile_index
    DataManager.latest_savefile_index
  end
  #
  # セーブファイルの決定
  #
  #
  def on_savefile_ok
    super
    if DataManager.load_game(@index)
      on_load_success
    else
      Sound.play_buzzer
    end
  end
  #
  # ロード成功時の処理
  #
  #
  def on_load_success
    Sound.play_load
    fadeout_all
    $game_system.on_after_load
    SceneManager.goto(Scene_Map)
  end
end
