#
# バトル画面で、使用するアイテムを選択するウィンドウです。
#

class Window_BattleItem < Window_ItemList
  #
  # オブジェクト初期化
  #
  # info_viewport : 情報表示用ビューポート
  #
  def initialize(help_window, info_viewport)
    y = help_window.height
    super(0, y, Graphics.width, info_viewport.rect.y - y)
    self.visible = false
    @help_window = help_window
    @info_viewport = info_viewport
  end
  #
  # アイテムをリストに含めるかどうか
  #
  #
  def include?(item)
    $game_party.usable?(item)
  end
  #
  # ウィンドウの表示
  #
  #
  def show
    select_last
    @help_window.show
    super
  end
  #
  # ウィンドウの非表示
  #
  #
  def hide
    @help_window.hide
    super
  end
end
