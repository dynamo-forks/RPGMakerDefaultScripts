#
# ゲームオーバー画面の処理を行うクラスです。
#

class Scene_Gameover < Scene_Base
  #
  # 開始処理
  #
  #
  def start
    super
    play_gameover_music
    fadeout_frozen_graphics
    create_background
  end
  #
  # 終了処理
  #
  #
  def terminate
    super
    dispose_background
  end
  #
  # フレーム更新
  #
  #
  def update
    super
    goto_title if Input.trigger?(:C)
  end
  #
  # トランジション実行
  #
  #
  def perform_transition
    Graphics.transition(fadein_speed)
  end
  #
  # ゲームオーバー画面の音楽演奏
  #
  #
  def play_gameover_music
    RPG::BGM.stop
    RPG::BGS.stop
    $data_system.gameover_me.play
  end
  #
  # 固定済みグラフィックのフェードアウト
  #
  #
  def fadeout_frozen_graphics
    Graphics.transition(fadeout_speed)
    Graphics.freeze
  end
  #
  # 背景の作成
  #
  #
  def create_background
    @sprite = Sprite.new
    @sprite.bitmap = Cache.system("GameOver")
  end
  #
  # 背景の解放
  #
  #
  def dispose_background
    @sprite.bitmap.dispose
    @sprite.dispose
  end
  #
  # フェードアウト速度の取得
  #
  #
  def fadeout_speed
    return 60
  end
  #
  # フェードイン速度の取得
  #
  #
  def fadein_speed
    return 120
  end
  #
  # タイトル画面へ遷移
  #
  #
  def goto_title
    fadeout_all
    SceneManager.goto(Scene_Title)
  end
end
