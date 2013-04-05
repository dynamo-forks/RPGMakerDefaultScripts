#encoding:utf-8
#
# 選單畫面中，顯示隊伍成員狀態的視窗
#

class Window_MenuStatus < Window_Selectable
  #
  # 定義案例變量
  #
  #
  attr_reader   :pending_index            # 保留位置（整隊用）
  #
  # 初始化物件
  #
  #
  def initialize(x, y)
    super(x, y, window_width, window_height)
    @pending_index = -1
    refresh
  end
  #
  # 取得視窗的寬度
  #
  #
  def window_width
    Graphics.width - 160
  end
  #
  # 取得視窗的高度
  #
  #
  def window_height
    Graphics.height
  end
  #
  # 取得專案數
  #
  #
  def item_max
    $game_party.members.size
  end
  #
  # 取得專案的高度
  #
  #
  def item_height
    (height - standard_padding * 2) / 4
  end
  #
  # 繪制專案
  #
  #
  def draw_item(index)
    actor = $game_party.members[index]
    enabled = $game_party.battle_members.include?(actor)
    rect = item_rect(index)
    draw_item_background(index)
    draw_actor_face(actor, rect.x + 1, rect.y + 1, enabled)
    draw_actor_simple_status(actor, rect.x + 108, rect.y + line_height / 2)
  end
  #
  # 繪制專案的背景
  #
  #
  def draw_item_background(index)
    if index == @pending_index
      contents.fill_rect(item_rect(index), pending_color)
    end
  end
  #
  # 按下確定鍵時的處理
  #
  #
  def process_ok
    super
    $game_party.menu_actor = $game_party.members[index]
  end
  #
  # 返回上一個選擇的位置
  #
  #
  def select_last
    select($game_party.menu_actor.index || 0)
  end
  #
  # 設定保留位置（整隊用）
  #
  #
  def pending_index=(index)
    last_pending_index = @pending_index
    @pending_index = index
    redraw_item(@pending_index)
    redraw_item(last_pending_index)
  end
end
