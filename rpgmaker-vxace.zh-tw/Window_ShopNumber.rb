#encoding:utf-8
#
# 商店畫面中，輸入“物品買入／賣出數量”的視窗。
#

class Window_ShopNumber < Window_Selectable
  #
  # 定義案例變量
  #
  #
  attr_reader   :number                   # 數量
  #
  # 初始化物件
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
  # 取得視窗的寬度
  #
  #
  def window_width
    return 304
  end
  #
  # 設定物品、最大值、價格、貨幣單位
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
  # 設定貨幣單位
  #
  #
  def currency_unit=(currency_unit)
    @currency_unit = currency_unit
    refresh
  end
  #
  # 重新整理
  #
  #
  def refresh
    contents.clear
    draw_item_name(@item, 0, item_y)
    draw_number
    draw_total_price
  end
  #
  # 繪制數量
  #
  #
  def draw_number
    change_color(normal_color)
    draw_text(cursor_x - 28, item_y, 22, line_height, "×")
    draw_text(cursor_x, item_y, cursor_width - 4, line_height, @number, 2)
  end
  #
  # 繪制總價
  #
  #
  def draw_total_price
    width = contents_width - 8
    draw_currency_value(@price * @number, @currency_unit, 4, price_y, width)
  end
  #
  # 顯示物品名稱行的 Y 坐標
  #
  #
  def item_y
    contents_height / 2 - line_height * 3 / 2
  end
  #
  # 顯示價格行的 Y 坐標
  #
  #
  def price_y
    contents_height / 2 + line_height / 2
  end
  #
  # 取得游標的寬度
  #
  #
  def cursor_width
    figures * 10 + 12
  end
  #
  # 取得游標的 X 坐標
  #
  #
  def cursor_x
    contents_width - cursor_width - 4
  end
  #
  # 取得數量顯示的最大列數
  #
  #
  def figures
    return 2
  end
  #
  # 更新畫面
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
  # 更新數量
  #
  #
  def update_number
    change_number(1)   if Input.repeat?(:RIGHT)
    change_number(-1)  if Input.repeat?(:LEFT)
    change_number(10)  if Input.repeat?(:UP)
    change_number(-10) if Input.repeat?(:DOWN)
  end
  #
  # 變更數量
  #
  #
  def change_number(amount)
    @number = [[@number + amount, @max].min, 1].max
  end
  #
  # 更新游標
  #
  #
  def update_cursor
    cursor_rect.set(cursor_x, item_y, cursor_width, line_height)
  end
end
