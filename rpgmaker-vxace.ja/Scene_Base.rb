#
# ゲーム中の全てのシーンのスーパークラスです。
#

class Scene_Base
  #
  # メイン
  #
  #
  def main
    start
    post_start
    update until scene_changing?
    pre_terminate
    terminate
  end
  #
  # 開始処理
  #
  #
  def start
    create_main_viewport
  end
  #
  # 開始後処理
  #
  #
  def post_start
    perform_transition
    Input.update
  end
  #
  # シーン変更中判定
  #
  #
  def scene_changing?
    SceneManager.scene != self
  end
  #
  # フレーム更新
  #
  #
  def update
    update_basic
  end
  #
  # フレーム更新（基本）
  #
  #
  def update_basic
    Graphics.update
    Input.update
    update_all_windows
  end
  #
  # 終了前処理
  #
  #
  def pre_terminate
  end
  #
  # 終了処理
  #
  #
  def terminate
    Graphics.freeze
    dispose_all_windows
    dispose_main_viewport
  end
  #
  # トランジション実行
  #
  #
  def perform_transition
    Graphics.transition(transition_speed)
  end
  #
  # トランジション速度の取得
  #
  #
  def transition_speed
    return 10
  end
  #
  # ビューポートの作成
  #
  #
  def create_main_viewport
    @viewport = Viewport.new
    @viewport.z = 200
  end
  #
  # ビューポートの解放
  #
  #
  def dispose_main_viewport
    @viewport.dispose
  end
  #
  # 全ウィンドウの更新
  #
  #
  def update_all_windows
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      ivar.update if ivar.is_a?(Window)
    end
  end
  #
  # 全ウィンドウの解放
  #
  #
  def dispose_all_windows
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      ivar.dispose if ivar.is_a?(Window)
    end
  end
  #
  # 呼び出し元のシーンへ戻る
  #
  #
  def return_scene
    SceneManager.return
  end
  #
  # 各種サウンドとグラフィックの一括フェードアウト
  #
  #
  def fadeout_all(time = 1000)
    RPG::BGM.fade(time)
    RPG::BGS.fade(time)
    RPG::ME.fade(time)
    Graphics.fadeout(time * Graphics.frame_rate / 1000)
    RPG::BGM.stop
    RPG::BGS.stop
    RPG::ME.stop
  end
  #
  # ゲームオーバー判定
  #
  # パーティが全滅状態ならゲームオーバー画面へ遷移する。
  #
  def check_gameover
    SceneManager.goto(Scene_Gameover) if $game_party.all_dead?
  end
end
