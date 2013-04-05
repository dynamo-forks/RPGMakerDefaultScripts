#encoding:utf-8
#
# 游戲中所有 Scene 類（場景類）的父類
#

class Scene_Base
  #
  # 主邏輯
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
  # 開始處理
  #
  #
  def start
    create_main_viewport
  end
  #
  # 開始後處理
  #
  #
  def post_start
    perform_transition
    Input.update
  end
  #
  # 判定是否變更場景中
  #
  #
  def scene_changing?
    SceneManager.scene != self
  end
  #
  # 更新畫面
  #
  #
  def update
    update_basic
  end
  #
  # 更新畫面（基礎）
  #
  #
  def update_basic
    Graphics.update
    Input.update
    update_all_windows
  end
  #
  # 結束前處理
  #
  #
  def pre_terminate
  end
  #
  # 結束處理
  #
  #
  def terminate
    Graphics.freeze
    dispose_all_windows
    dispose_main_viewport
  end
  #
  # 執行漸變
  #
  #
  def perform_transition
    Graphics.transition(transition_speed)
  end
  #
  # 取得漸變速度
  #
  #
  def transition_speed
    return 10
  end
  #
  # 生成顯示連接埠
  #
  #
  def create_main_viewport
    @viewport = Viewport.new
    @viewport.z = 200
  end
  #
  # 釋放顯示連接埠
  #
  #
  def dispose_main_viewport
    @viewport.dispose
  end
  #
  # 更新所有視窗
  #
  #
  def update_all_windows
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      ivar.update if ivar.is_a?(Window)
    end
  end
  #
  # 釋放所有視窗
  #
  #
  def dispose_all_windows
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      ivar.dispose if ivar.is_a?(Window)
    end
  end
  #
  # 返回前一個場景
  #
  #
  def return_scene
    SceneManager.return
  end
  #
  # 淡出各種音效以及圖像
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
  # 游戲結束的判定
  #
  # 如果全滅則切換到游戲結束畫面。
  #
  def check_gameover
    SceneManager.goto(Scene_Gameover) if $game_party.all_dead?
  end
end
