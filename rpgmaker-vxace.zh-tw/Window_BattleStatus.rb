#encoding:utf-8
#
# 戰鬥畫面中，顯示“隊伍成員狀態”的視窗。
#

class Window_BattleStatus < Window_Selectable
  #
  # 初始化物件
  #
  #
  def initialize
    super(0, 0, window_width, window_height)
    refresh
    self.openness = 0
  end
  #
  # 取得視窗的寬度
  #
  #
  def window_width
    Graphics.width - 128
  end
  #
  # 取得視窗的高度
  #
  #
  def window_height
    fitting_height(visible_line_number)
  end
  #
  # 取得顯示行數
  #
  #
  def visible_line_number
    return 4
  end
  #
  # 取得專案數
  #
  #
  def item_max
    $game_party.battle_members.size
  end
  #
  # 重新整理
  #
  #
  def refresh
    contents.clear
    draw_all_items
  end
  #
  # 繪制專案
  #
  #
  def draw_item(index)
    actor = $game_party.battle_members[index]
    draw_basic_area(basic_area_rect(index), actor)
    draw_gauge_area(gauge_area_rect(index), actor)
  end
  #
  # 取得基本區域的矩形
  #
  #
  def basic_area_rect(index)
    rect = item_rect_for_text(index)
    rect.width -= gauge_area_width + 10
    rect
  end
  #
  # 取得值槽區域的矩形
  #
  #
  def gauge_area_rect(index)
    rect = item_rect_for_text(index)
    rect.x += rect.width - gauge_area_width
    rect.width = gauge_area_width
    rect
  end
  #
  # 取得值槽區域的寬度
  #
  #
  def gauge_area_width
    return 220
  end
  #
  # 繪制基本區域
  #
  #
  def draw_basic_area(rect, actor)
    draw_actor_name(actor, rect.x + 0, rect.y, 100)
    draw_actor_icons(actor, rect.x + 104, rect.y, rect.width - 104)
  end
  #
  # 繪制值槽區域
  #
  #
  def draw_gauge_area(rect, actor)
    if $data_system.opt_display_tp
      draw_gauge_area_with_tp(rect, actor)
    else
      draw_gauge_area_without_tp(rect, actor)
    end
  end
  #
  # 繪制值槽區域（內含 TP）
  #
  #
  def draw_gauge_area_with_tp(rect, actor)
    draw_actor_hp(actor, rect.x + 0, rect.y, 72)
    draw_actor_mp(actor, rect.x + 82, rect.y, 64)
    draw_actor_tp(actor, rect.x + 156, rect.y, 64)
  end
  #
  # 繪制值槽區域（不內含 TP）
  #
  #
  def draw_gauge_area_without_tp(rect, actor)
    draw_actor_hp(actor, rect.x + 0, rect.y, 134)
    draw_actor_mp(actor, rect.x + 144,  rect.y, 76)
  end
end
