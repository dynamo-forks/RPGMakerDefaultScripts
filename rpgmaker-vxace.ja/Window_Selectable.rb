#
# カーソルの移動やスクロールの機能を持つウィンドウクラスです。
#

class Window_Selectable < Window_Base
  #
  # 公開インスタンス変数
  #
  #
  attr_reader   :index                    # カーソル位置
  attr_reader   :help_window              # ヘルプウィンドウ
  attr_accessor :cursor_fix               # カーソル固定フラグ
  attr_accessor :cursor_all               # カーソル全選択フラグ
  #
  # オブジェクト初期化
  #
  #
  def initialize(x, y, width, height)
    super
    @index = -1
    @handler = {}
    @cursor_fix = false
    @cursor_all = false
    update_padding
    deactivate
  end
  #
  # 桁数の取得
  #
  #
  def col_max
    return 1
  end
  #
  # 横に項目が並ぶときの空白の幅を取得
  #
  #
  def spacing
    return 32
  end
  #
  # 項目数の取得
  #
  #
  def item_max
    return 0
  end
  #
  # 項目の幅を取得
  #
  #
  def item_width
    (width - standard_padding * 2 + spacing) / col_max - spacing
  end
  #
  # 項目の高さを取得
  #
  #
  def item_height
    line_height
  end
  #
  # 行数の取得
  #
  #
  def row_max
    [(item_max + col_max - 1) / col_max, 1].max
  end
  #
  # ウィンドウ内容の高さを計算
  #
  #
  def contents_height
    [super - super % item_height, row_max * item_height].max
  end
  #
  # パディングの更新
  #
  #
  def update_padding
    super
    update_padding_bottom
  end
  #
  # 下端パディングの更新
  #
  #
  def update_padding_bottom
    surplus = (height - standard_padding * 2) % item_height
    self.padding_bottom = padding + surplus
  end
  #
  # 高さの設定
  #
  #
  def height=(height)
    super
    update_padding
  end
  #
  # アクティブ状態の変更
  #
  #
  def active=(active)
    super
    update_cursor
    call_update_help
  end
  #
  # カーソル位置の設定
  #
  #
  def index=(index)
    @index = index
    update_cursor
    call_update_help
  end
  #
  # 項目の選択
  #
  #
  def select(index)
    self.index = index if index
  end
  #
  # 項目の選択解除
  #
  #
  def unselect
    self.index = -1
  end
  #
  # 現在の行の取得
  #
  #
  def row
    index / col_max
  end
  #
  # 先頭の行の取得
  #
  #
  def top_row
    oy / item_height
  end
  #
  # 先頭の行の設定
  #
  #
  def top_row=(row)
    row = 0 if row < 0
    row = row_max - 1 if row > row_max - 1
    self.oy = row * item_height
  end
  #
  # 1 ページに表示できる行数の取得
  #
  #
  def page_row_max
    (height - padding - padding_bottom) / item_height
  end
  #
  # 1 ページに表示できる項目数の取得
  #
  #
  def page_item_max
    page_row_max * col_max
  end
  #
  # 横選択判定
  #
  #
  def horizontal?
    page_row_max == 1
  end
  #
  # 末尾の行の取得
  #
  #
  def bottom_row
    top_row + page_row_max - 1
  end
  #
  # 末尾の行の設定
  #
  #
  def bottom_row=(row)
    self.top_row = row - (page_row_max - 1)
  end
  #
  # 項目を描画する矩形の取得
  #
  #
  def item_rect(index)
    rect = Rect.new
    rect.width = item_width
    rect.height = item_height
    rect.x = index % col_max * (item_width + spacing)
    rect.y = index / col_max * item_height
    rect
  end
  #
  # 項目を描画する矩形の取得（テキスト用）
  #
  #
  def item_rect_for_text(index)
    rect = item_rect(index)
    rect.x += 4
    rect.width -= 8
    rect
  end
  #
  # ヘルプウィンドウの設定
  #
  #
  def help_window=(help_window)
    @help_window = help_window
    call_update_help
  end
  #
  # 動作に対応するハンドラの設定
  #
  # method : ハンドラとして設定するメソッド (Method オブジェクト)
  #
  def set_handler(symbol, method)
    @handler[symbol] = method
  end
  #
  # ハンドラの存在確認
  #
  #
  def handle?(symbol)
    @handler.include?(symbol)
  end
  #
  # ハンドラの呼び出し
  #
  #
  def call_handler(symbol)
    @handler[symbol].call if handle?(symbol)
  end
  #
  # カーソルの移動可能判定
  #
  #
  def cursor_movable?
    active && open? && !@cursor_fix && !@cursor_all && item_max > 0
  end
  #
  # カーソルを下に移動
  #
  #
  def cursor_down(wrap = false)
    if index < item_max - col_max || (wrap && col_max == 1)
      select((index + col_max) % item_max)
    end
  end
  #
  # カーソルを上に移動
  #
  #
  def cursor_up(wrap = false)
    if index >= col_max || (wrap && col_max == 1)
      select((index - col_max + item_max) % item_max)
    end
  end
  #
  # カーソルを右に移動
  #
  #
  def cursor_right(wrap = false)
    if col_max >= 2 && (index < item_max - 1 || (wrap && horizontal?))
      select((index + 1) % item_max)
    end
  end
  #
  # カーソルを左に移動
  #
  #
  def cursor_left(wrap = false)
    if col_max >= 2 && (index > 0 || (wrap && horizontal?))
      select((index - 1 + item_max) % item_max)
    end
  end
  #
  # カーソルを 1 ページ後ろに移動
  #
  #
  def cursor_pagedown
    if top_row + page_row_max < row_max
      self.top_row += page_row_max
      select([@index + page_item_max, item_max - 1].min)
    end
  end
  #
  # カーソルを 1 ページ前に移動
  #
  #
  def cursor_pageup
    if top_row > 0
      self.top_row -= page_row_max
      select([@index - page_item_max, 0].max)
    end
  end
  #
  # フレーム更新
  #
  #
  def update
    super
    process_cursor_move
    process_handling
  end
  #
  # カーソルの移動処理
  #
  #
  def process_cursor_move
    return unless cursor_movable?
    last_index = @index
    cursor_down (Input.trigger?(:DOWN))  if Input.repeat?(:DOWN)
    cursor_up   (Input.trigger?(:UP))    if Input.repeat?(:UP)
    cursor_right(Input.trigger?(:RIGHT)) if Input.repeat?(:RIGHT)
    cursor_left (Input.trigger?(:LEFT))  if Input.repeat?(:LEFT)
    cursor_pagedown   if !handle?(:pagedown) && Input.trigger?(:R)
    cursor_pageup     if !handle?(:pageup)   && Input.trigger?(:L)
    Sound.play_cursor if @index != last_index
  end
  #
  # 決定やキャンセルなどのハンドリング処理
  #
  #
  def process_handling
    return unless open? && active
    return process_ok       if ok_enabled?        && Input.trigger?(:C)
    return process_cancel   if cancel_enabled?    && Input.trigger?(:B)
    return process_pagedown if handle?(:pagedown) && Input.trigger?(:R)
    return process_pageup   if handle?(:pageup)   && Input.trigger?(:L)
  end
  #
  # 決定処理の有効状態を取得
  #
  #
  def ok_enabled?
    handle?(:ok)
  end
  #
  # キャンセル処理の有効状態を取得
  #
  #
  def cancel_enabled?
    handle?(:cancel)
  end
  #
  # 決定ボタンが押されたときの処理
  #
  #
  def process_ok
    if current_item_enabled?
      Sound.play_ok
      Input.update
      deactivate
      call_ok_handler
    else
      Sound.play_buzzer
    end
  end
  #
  # 決定ハンドラの呼び出し
  #
  #
  def call_ok_handler
    call_handler(:ok)
  end
  #
  # キャンセルボタンが押されたときの処理
  #
  #
  def process_cancel
    Sound.play_cancel
    Input.update
    deactivate
    call_cancel_handler
  end
  #
  # キャンセルハンドラの呼び出し
  #
  #
  def call_cancel_handler
    call_handler(:cancel)
  end
  #
  # L ボタン（PageUp）が押されたときの処理
  #
  #
  def process_pageup
    Sound.play_cursor
    Input.update
    deactivate
    call_handler(:pageup)
  end
  #
  # R ボタン（PageDown）が押されたときの処理
  #
  #
  def process_pagedown
    Sound.play_cursor
    Input.update
    deactivate
    call_handler(:pagedown)
  end
  #
  # カーソルの更新
  #
  #
  def update_cursor
    if @cursor_all
      cursor_rect.set(0, 0, contents.width, row_max * item_height)
      self.top_row = 0
    elsif @index < 0
      cursor_rect.empty
    else
      ensure_cursor_visible
      cursor_rect.set(item_rect(@index))
    end
  end
  #
  # カーソル位置が画面内になるようにスクロール
  #
  #
  def ensure_cursor_visible
    self.top_row = row if row < top_row
    self.bottom_row = row if row > bottom_row
  end
  #
  # ヘルプウィンドウ更新メソッドの呼び出し
  #
  #
  def call_update_help
    update_help if active && @help_window
  end
  #
  # ヘルプウィンドウの更新
  #
  #
  def update_help
    @help_window.clear
  end
  #
  # 選択項目の有効状態を取得
  #
  #
  def current_item_enabled?
    return true
  end
  #
  # 全項目の描画
  #
  #
  def draw_all_items
    item_max.times {|i| draw_item(i) }
  end
  #
  # 項目の描画
  #
  #
  def draw_item(index)
  end
  #
  # 項目の消去
  #
  #
  def clear_item(index)
    contents.clear_rect(item_rect(index))
  end
  #
  # 項目の再描画
  #
  #
  def redraw_item(index)
    clear_item(index) if index >= 0
    draw_item(index)  if index >= 0
  end
  #
  # 選択項目の再描画
  #
  #
  def redraw_current_item
    redraw_item(@index)
  end
  #
  # リフレッシュ
  #
  #
  def refresh
    contents.clear
    draw_all_items
  end
end
