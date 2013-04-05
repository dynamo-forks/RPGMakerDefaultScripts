#
# デバッグ画面で、スイッチや変数のブロックを指定するウィンドウです。
#

class Window_DebugLeft < Window_Selectable
  #
  # クラス変数
  #
  #
  @@last_top_row = 0                      # 先頭の行 保存用
  @@last_index   = 0                      # カーソル位置 保存用
  #
  # 公開インスタンス変数
  #
  #
  attr_reader   :right_window             # 右ウィンドウ
  #
  # オブジェクト初期化
  #
  #
  def initialize(x, y)
    super(x, y, window_width, window_height)
    refresh
    self.top_row = @@last_top_row
    select(@@last_index)
    activate
  end
  #
  # ウィンドウ幅の取得
  #
  #
  def window_width
    return 164
  end
  #
  # ウィンドウ高さの取得
  #
  #
  def window_height
    Graphics.height
  end
  #
  # 項目数の取得
  #
  #
  def item_max
    @item_max || 0
  end
  #
  # フレーム更新
  #
  #
  def update
    super
    return unless @right_window
    @right_window.mode = mode
    @right_window.top_id = top_id
  end
  #
  # モードの取得
  #
  #
  def mode
    index < @switch_max ? :switch : :variable
  end
  #
  # 先頭に表示する ID の取得
  #
  #
  def top_id
    (index - (index < @switch_max ? 0 : @switch_max)) * 10 + 1
  end
  #
  # リフレッシュ
  #
  #
  def refresh
    @switch_max = ($data_system.switches.size - 1 + 9) / 10
    @variable_max = ($data_system.variables.size - 1 + 9) / 10
    @item_max = @switch_max + @variable_max
    create_contents
    draw_all_items
  end
  #
  # 項目の描画
  #
  #
  def draw_item(index)
    if index < @switch_max
      n = index * 10
      text = sprintf("S [%04d-%04d]", n+1, n+10)
    else
      n = (index - @switch_max) * 10
      text = sprintf("V [%04d-%04d]", n+1, n+10)
    end
    draw_text(item_rect_for_text(index), text)
  end
  #
  # キャンセルボタンが押されたときの処理
  #
  #
  def process_cancel
    super
    @@last_top_row = top_row
    @@last_index = index
  end
  #
  # 右ウィンドウの設定
  #
  #
  def right_window=(right_window)
    @right_window = right_window
    update
  end
end
