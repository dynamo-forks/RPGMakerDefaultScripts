#encoding:utf-8
#
# 名字輸入畫面
#

class Scene_Name < Scene_MenuBase
  #
  # 準備
  #
  #
  def prepare(actor_id, max_char)
    @actor_id = actor_id
    @max_char = max_char
  end
  #
  # 開始處理
  #
  #
  def start
    super
    @actor = $game_actors[@actor_id]
    @edit_window = Window_NameEdit.new(@actor, @max_char)
    @input_window = Window_NameInput.new(@edit_window)
    @input_window.set_handler(:ok, method(:on_input_ok))
  end
  #
  # 輸入“確定”
  #
  #
  def on_input_ok
    @actor.name = @edit_window.name
    return_scene
  end
end
