#
# ショップ画面で、購入できる商品の一覧を表示するウィンドウです。
#

class Window_ShopBuy < Window_Selectable
  #
  # 公開インスタンス変数
  #
  #
  attr_reader   :status_window            # ステータスウィンドウ
  #
  # オブジェクト初期化
  #
  #
  def initialize(x, y, height, shop_goods)
    super(x, y, window_width, height)
    @shop_goods = shop_goods
    @money = 0
    refresh
    select(0)
  end
  #
  # ウィンドウ幅の取得
  #
  #
  def window_width
    return 304
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
    @data[index]
  end
  #
  # 所持金の設定
  #
  #
  def money=(money)
    @money = money
    refresh
  end
  #
  # 選択項目の有効状態を取得
  #
  #
  def current_item_enabled?
    enable?(@data[index])
  end
  #
  # 商品の値段を取得
  #
  #
  def price(item)
    @price[item]
  end
  #
  # アイテムを許可状態で表示するかどうか
  #
  #
  def enable?(item)
    item && price(item) <= @money && !$game_party.item_max?(item)
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
  #
  # アイテムリストの作成
  #
  #
  def make_item_list
    @data = []
    @price = {}
    @shop_goods.each do |goods|
      case goods[0]
      when 0;  item = $data_items[goods[1]]
      when 1;  item = $data_weapons[goods[1]]
      when 2;  item = $data_armors[goods[1]]
      end
      if item
        @data.push(item)
        @price[item] = goods[2] == 0 ? item.price : goods[3]
      end
    end
  end
  #
  # 項目の描画
  #
  #
  def draw_item(index)
    item = @data[index]
    rect = item_rect(index)
    draw_item_name(item, rect.x, rect.y, enable?(item))
    rect.width -= 4
    draw_text(rect, price(item), 2)
  end
  #
  # ステータスウィンドウの設定
  #
  #
  def status_window=(status_window)
    @status_window = status_window
    call_update_help
  end
  #
  # ヘルプテキスト更新
  #
  #
  def update_help
    @help_window.set_item(item) if @help_window
    @status_window.item = item if @status_window
  end
end
