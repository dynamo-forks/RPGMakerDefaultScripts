#encoding:utf-8
#
# 選單畫面
#

class Scene_Menu < Scene_MenuBase
  #
  # 開始處理
  #
  #
  def start
    super
    create_command_window
    create_gold_window
    create_status_window
  end
  #
  # 生成指令視窗
  #
  #
  def create_command_window
    @command_window = Window_MenuCommand.new
    @command_window.set_handler(:item,      method(:command_item))
    @command_window.set_handler(:skill,     method(:command_personal))
    @command_window.set_handler(:equip,     method(:command_personal))
    @command_window.set_handler(:status,    method(:command_personal))
    @command_window.set_handler(:formation, method(:command_formation))
    @command_window.set_handler(:save,      method(:command_save))
    @command_window.set_handler(:game_end,  method(:command_game_end))
    @command_window.set_handler(:cancel,    method(:return_scene))
  end
  #
  # 生成金錢視窗
  #
  #
  def create_gold_window
    @gold_window = Window_Gold.new
    @gold_window.x = 0
    @gold_window.y = Graphics.height - @gold_window.height
  end
  #
  # 生成狀態視窗
  #
  #
  def create_status_window
    @status_window = Window_MenuStatus.new(@command_window.width, 0)
  end
  #
  # 指令“物品”
  #
  #
  def command_item
    SceneManager.call(Scene_Item)
  end
  #
  # 指令“技能”“裝備”“狀態”
  #
  #
  def command_personal
    @status_window.select_last
    @status_window.activate
    @status_window.set_handler(:ok,     method(:on_personal_ok))
    @status_window.set_handler(:cancel, method(:on_personal_cancel))
  end
  #
  # 指令“整隊”
  #
  #
  def command_formation
    @status_window.select_last
    @status_window.activate
    @status_window.set_handler(:ok,     method(:on_formation_ok))
    @status_window.set_handler(:cancel, method(:on_formation_cancel))
  end
  #
  # 指令“存檔”
  #
  #
  def command_save
    SceneManager.call(Scene_Save)
  end
  #
  # 指令“結束游戲”
  #
  #
  def command_game_end
    SceneManager.call(Scene_End)
  end
  #
  # 個人指令“確定”
  #
  #
  def on_personal_ok
    case @command_window.current_symbol
    when :skill
      SceneManager.call(Scene_Skill)
    when :equip
      SceneManager.call(Scene_Equip)
    when :status
      SceneManager.call(Scene_Status)
    end
  end
  #
  # 個人指令“取消”
  #
  #
  def on_personal_cancel
    @status_window.unselect
    @command_window.activate
  end
  #
  # 整隊“確定”
  #
  #
  def on_formation_ok
    if @status_window.pending_index >= 0
      $game_party.swap_order(@status_window.index,
                             @status_window.pending_index)
      @status_window.pending_index = -1
      @status_window.redraw_item(@status_window.index)
    else
      @status_window.pending_index = @status_window.index
    end
    @status_window.activate
  end
  #
  # 整隊“取消”
  #
  #
  def on_formation_cancel
    if @status_window.pending_index >= 0
      @status_window.pending_index = -1
      @status_window.activate
    else
      @status_window.unselect
      @command_window.activate
    end
  end
end