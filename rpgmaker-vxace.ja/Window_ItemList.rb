#
# アイテム画面で、所持アイテムの一覧を表示するウィンドウです。
#

class Window_ItemList < Window_Selectable
  #
  # オブジェクト初期化
  #
  #
  def initialize(x, y, width, height)
    super
    @category = :none
    @data = []
  end
  #
  # カテゴリの設定
  #
  #
  def category=(category)
    return if @category == category
    @category = category
    refresh
    self.oy = 0
  end
  #
  # 桁数の取得
  #
  #
  def col_max
    return 2
  end
  #
  # 項目数の取得
  #
  #
  def item_max
    @data ? @data.size : 1
  end
  #
  # アイテムの取得
  #
  #
  def item
    @data && index >= 0 ? @data[index] : nil
  end
  #
  # 選択項目の有効状態を取得
  #
  #
  def current_item_enabled?
    enable?(@data[index])
  end
  #
  # アイテムをリストに含めるかどうか
  #
  #
  def include?(item)
    case @category
    when :item
      item.is_a?(RPG::Item) && !item.key_item?
    when :weapon
      item.is_a?(RPG::Weapon)
    when :armor
      item.is_a?(RPG::Armor)
    when :key_item
      item.is_a?(RPG::Item) && item.key_item?
    else
      false
    end
  end
  #
  # アイテムを許可状態で表示するかどうか
  #
  #
  def enable?(item)
    $game_party.usable?(item)
  end
  #
  # アイテムリストの作成
  #
  #
  def make_item_list
    @data = $game_party.all_items.select {|item| include?(item) }
    @data.push(nil) if include?(nil)
  end
  #
  # 前回の選択位置を復帰
  #
  #
  def select_last
    select(@data.index($game_party.last_item.object) || 0)
  end
  #
  # 項目の描画
  #
  #
  def draw_item(index)
    item = @data[index]
    if item
      rect = item_rect(index)
      rect.width -= 4
      draw_item_name(item, rect.x, rect.y, enable?(item))
      draw_item_number(rect, item)
    end
  end
  #
  # アイテムの個数を描画
  #
  #
  def draw_item_number(rect, item)
    draw_text(rect, sprintf(":%2d", $game_party.item_number(item)), 2)
  end
  #
  # ヘルプテキスト更新
  #
  #
  def update_help
    @help_window.set_item(item)
  end
  #
  # リフレッシュ
  #
  #
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
end
