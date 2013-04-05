#encoding:utf-8
#
# 所有選單畫面的基本處理
#

class Scene_MenuBase < Scene_Base
  #
  # 開始處理
  #
  #
  def start
    super
    create_background
    @actor = $game_party.menu_actor
  end
  #
  # 結束處理
  #
  #
  def terminate
    super
    dispose_background
  end
  #
  # 生成背景
  #
  #
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  #
  # 釋放背景
  #
  #
  def dispose_background
    @background_sprite.dispose
  end
  #
  # 生成說明視窗
  #
  #
  def create_help_window
    @help_window = Window_Help.new
    @help_window.viewport = @viewport
  end
  #
  # 切換到下一個角色
  #
  #
  def next_actor
    @actor = $game_party.menu_actor_next
    on_actor_change
  end
  #
  # 切換到上一個角色
  #
  #
  def prev_actor
    @actor = $game_party.menu_actor_prev
    on_actor_change
  end
  #
  # 切換角色
  #
  #
  def on_actor_change
  end
end
