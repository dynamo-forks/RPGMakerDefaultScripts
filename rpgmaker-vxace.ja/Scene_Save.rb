#
# セーブ画面の処理を行うクラスです。
#

class Scene_Save < Scene_File
  #
  # ヘルプウィンドウのテキストを取得
  #
  #
  def help_window_text
    Vocab::SaveMessage
  end
  #
  # 最初に選択状態にするファイルインデックスを取得
  #
  #
  def first_savefile_index
    DataManager.last_savefile_index
  end
  #
  # セーブファイルの決定
  #
  #
  def on_savefile_ok
    super
    if DataManager.save_game(@index)
      on_save_success
    else
      Sound.play_buzzer
    end
  end
  #
  # セーブ成功時の処理
  #
  #
  def on_save_success
    Sound.play_save
    return_scene
  end
end
