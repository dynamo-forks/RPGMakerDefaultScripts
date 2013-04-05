#
# バトル画面で、パーティメンバーのステータスを表示するウィンドウです。
#

class Window_BattleStatus < Window_Selectable
  #
  # オブジェクト初期化
  #
  #
  def initialize
    super(0, 0, window_width, window_height)
    refresh
    self.openness = 0
  end
  #
  # ウィンドウ幅の取得
  #
  #
  def window_width
    Graphics.width - 128
  end
  #
  # ウィンドウ高さの取得
  #
  #
  def window_height
    fitting_height(visible_line_number)
  end
  #
  # 表示行数の取得
  #
  #
  def visible_line_number
    return 4
  end
  #
  # 項目数の取得
  #
  #
  def item_max
    $game_party.battle_members.size
  end
  #
  # リフレッシュ
  #
  #
  def refresh
    contents.clear
    draw_all_items
  end
  #
  # 項目の描画
  #
  #
  def draw_item(index)
    actor = $game_party.battle_members[index]
    draw_basic_area(basic_area_rect(index), actor)
    draw_gauge_area(gauge_area_rect(index), actor)
  end
  #
  # 基本エリアの矩形を取得
  #
  #
  def basic_area_rect(index)
    rect = item_rect_for_text(index)
    rect.width -= gauge_area_width + 10
    rect
  end
  #
  # ゲージエリアの矩形を取得
  #
  #
  def gauge_area_rect(index)
    rect = item_rect_for_text(index)
    rect.x += rect.width - gauge_area_width
    rect.width = gauge_area_width
    rect
  end
  #
  # ゲージエリアの幅を取得
  #
  #
  def gauge_area_width
    return 220
  end
  #
  # 基本エリアの描画
  #
  #
  def draw_basic_area(rect, actor)
    draw_actor_name(actor, rect.x + 0, rect.y, 100)
    draw_actor_icons(actor, rect.x + 104, rect.y, rect.width - 104)
  end
  #
  # ゲージエリアの描画
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
  # ゲージエリアの描画（TP あり）
  #
  #
  def draw_gauge_area_with_tp(rect, actor)
    draw_actor_hp(actor, rect.x + 0, rect.y, 72)
    draw_actor_mp(actor, rect.x + 82, rect.y, 64)
    draw_actor_tp(actor, rect.x + 156, rect.y, 64)
  end
  #
  # ゲージエリアの描画（TP なし）
  #
  #
  def draw_gauge_area_without_tp(rect, actor)
    draw_actor_hp(actor, rect.x + 0, rect.y, 134)
    draw_actor_mp(actor, rect.x + 144,  rect.y, 76)
  end
end
