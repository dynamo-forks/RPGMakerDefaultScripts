#
# アイテム画面またはショップ画面で、通常アイテムや装備品の分類を選択するウィ
# ンドウです。
#

class Window_ItemCategory < Window_HorzCommand
  #
  # 公開インスタンス変数
  #
  #
  attr_reader   :item_window
  #
  # オブジェクト初期化
  #
  #
  def initialize
    super(0, 0)
  end
  #
  # ウィンドウ幅の取得
  #
  #
  def window_width
    Graphics.width
  end
  #
  # 桁数の取得
  #
  #
  def col_max
    return 4
  end
  #
  # フレーム更新
  #
  #
  def update
    super
    @item_window.category = current_symbol if @item_window
  end
  #
  # コマンドリストの作成
  #
  #
  def make_command_list
    add_command(Vocab::item,     :item)
    add_command(Vocab::weapon,   :weapon)
    add_command(Vocab::armor,    :armor)
    add_command(Vocab::key_item, :key_item)
  end
  #
  # アイテムウィンドウの設定
  #
  #
  def item_window=(item_window)
    @item_window = item_window
    update
  end
end
