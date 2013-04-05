#
# ショップ画面で、購入または売却するアイテムの個数を入力するウィンドウです。
#

class Window_ShopNumber < Window_Selectable
  #
  # 公開インスタンス変数
  #
  #
  attr_reader   :number                   # 入力された個数
  #
  # オブジェクト初期化
  #
  #
  def initialize(x, y, height)
    super(x, y, window_width, height)
    @item = nil
    @max = 1
    @price = 0
    @number = 1
    @currency_unit = Vocab::currency_unit
  end
  #
  # ウィンドウ幅の取得
  #
  #
  def window_width
    return 304
  end
  #
  # アイテム、最大個数、価格、通貨単位の設定
  #
  #
  def set(item, max, price, currency_unit = nil)
    @item = item
    @max = max
    @price = price
    @currency_unit = currency_unit if currency_unit
    @number = 1
    refresh
  end
  #
  # 通貨単位の設定
  #
  #
  def currency_unit=(currency_unit)
    @currency_unit = currency_unit
    refresh
  end
  #
  # リフレッシュ
  #
  #
  def refresh
    contents.clear
    draw_item_name(@item, 0, item_y)
    draw_number
    draw_total_price
  end
  #
  # 個数の描画
  #
  #
  def draw_number
    change_color(normal_color)
    draw_text(cursor_x - 28, item_y, 22, line_height, "×")
    draw_text(cursor_x, item_y, cursor_width - 4, line_height, @number, 2)
  end
  #
  # 総額の描画
  #
  #
  def draw_total_price
    width = contents_width - 8
    draw_currency_value(@price * @number, @currency_unit, 4, price_y, width)
  end
  #
  # アイテム名表示行の Y 座標
  #
  #
  def item_y
    contents_height / 2 - line_height * 3 / 2
  end
  #
  # 値段表示行の Y 座標
  #
  #
  def price_y
    contents_height / 2 + line_height / 2
  end
  #
  # カーソルの幅を取得
  #
  #
  def cursor_width
    figures * 10 + 12
  end
  #
  # カーソルの X 座標を取得
  #
  #
  def cursor_x
    contents_width - cursor_width - 4
  end
  #
  # 個数表示の最大桁数を取得
  #
  #
  def figures
    return 2
  end
  #
  # フレーム更新
  #
  #
  def update
    super
    if active
      last_number = @number
      update_number
      if @number != last_number
        Sound.play_cursor
        refresh
      end
    end
  end
  #
  # 個数の更新
  #
  #
  def update_number
    change_number(1)   if Input.repeat?(:RIGHT)
    change_number(-1)  if Input.repeat?(:LEFT)
    change_number(10)  if Input.repeat?(:UP)
    change_number(-10) if Input.repeat?(:DOWN)
  end
  #
  # 個数の変更
  #
  #
  def change_number(amount)
    @number = [[@number + amount, @max].min, 1].max
  end
  #
  # カーソルの更新
  #
  #
  def update_cursor
    cursor_rect.set(cursor_x, item_y, cursor_width, line_height)
  end
end
