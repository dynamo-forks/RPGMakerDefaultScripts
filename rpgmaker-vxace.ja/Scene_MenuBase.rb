#
# メニュー画面系の基本処理を行うクラスです。
#

class Scene_MenuBase < Scene_Base
  #
  # 開始処理
  #
  #
  def start
    super
    create_background
    @actor = $game_party.menu_actor
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
  # 背景の作成
  #
  #
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  #
  # 背景の解放
  #
  #
  def dispose_background
    @background_sprite.dispose
  end
  #
  # ヘルプウィンドウの作成
  #
  #
  def create_help_window
    @help_window = Window_Help.new
    @help_window.viewport = @viewport
  end
  #
  # 次のアクターに切り替え
  #
  #
  def next_actor
    @actor = $game_party.menu_actor_next
    on_actor_change
  end
  #
  # 前のアクターに切り替え
  #
  #
  def prev_actor
    @actor = $game_party.menu_actor_prev
    on_actor_change
  end
  #
  # アクターの切り替え
  #
  #
  def on_actor_change
  end
end
