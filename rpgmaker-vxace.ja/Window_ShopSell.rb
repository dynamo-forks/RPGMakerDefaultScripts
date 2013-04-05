#
# ショップ画面で、売却のために所持アイテムの一覧を表示するウィンドウです。
#

class Window_ShopSell < Window_ItemList
  #
  # オブジェクト初期化
  #
  #
  def initialize(x, y, width, height)
    super(x, y, width, height)
  end
  #
  # 選択項目の有効状態を取得
  #
  #
  def current_item_enabled?
    enable?(@data[index])
  end
  #
  # アイテムを許可状態で表示するかどうか
  #
  #
  def enable?(item)
    item && item.price > 0
  end
end
