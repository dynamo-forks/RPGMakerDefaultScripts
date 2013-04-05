#
# 一般的なコマンド選択を行うウィンドウです。
#

class Window_Command < Window_Selectable
  #
  # オブジェクト初期化
  #
  #
  def initialize(x, y)
    clear_command_list
    make_command_list
    super(x, y, window_width, window_height)
    refresh
    select(0)
    activate
  end
  #
  # ウィンドウ幅の取得
  #
  #
  def window_width
    return 160
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
    item_max
  end
  #
  # 項目数の取得
  #
  #
  def item_max
    @list.size
  end
  #
  # コマンドリストのクリア
  #
  #
  def clear_command_list
    @list = []
  end
  #
  # コマンドリストの作成
  #
  #
  def make_command_list
  end
  #
  # コマンドの追加
  #
  # name    : コマンド名
  # symbol  : 対応するシンボル
  # enabled : 有効状態フラグ
  # ext     : 任意の拡張データ
  #
  def add_command(name, symbol, enabled = true, ext = nil)
    @list.push({:name=>name, :symbol=>symbol, :enabled=>enabled, :ext=>ext})
  end
  #
  # コマンド名の取得
  #
  #
  def command_name(index)
    @list[index][:name]
  end
  #
  # コマンドの有効状態を取得
  #
  #
  def command_enabled?(index)
    @list[index][:enabled]
  end
  #
  # 選択項目のコマンドデータを取得
  #
  #
  def current_data
    index >= 0 ? @list[index] : nil
  end
  #
  # 選択項目の有効状態を取得
  #
  #
  def current_item_enabled?
    current_data ? current_data[:enabled] : false
  end
  #
  # 選択項目のシンボルを取得
  #
  #
  def current_symbol
    current_data ? current_data[:symbol] : nil
  end
  #
  # 選択項目の拡張データを取得
  #
  #
  def current_ext
    current_data ? current_data[:ext] : nil
  end
  #
  # 指定されたシンボルを持つコマンドにカーソルを移動
  #
  #
  def select_symbol(symbol)
    @list.each_index {|i| select(i) if @list[i][:symbol] == symbol }
  end
  #
  # 指定された拡張データを持つコマンドにカーソルを移動
  #
  #
  def select_ext(ext)
    @list.each_index {|i| select(i) if @list[i][:ext] == ext }
  end
  #
  # 項目の描画
  #
  #
  def draw_item(index)
    change_color(normal_color, command_enabled?(index))
    draw_text(item_rect_for_text(index), command_name(index), alignment)
  end
  #
  # アライメントの取得
  #
  #
  def alignment
    return 0
  end
  #
  # 決定処理の有効状態を取得
  #
  #
  def ok_enabled?
    return true
  end
  #
  # 決定ハンドラの呼び出し
  #
  #
  def call_ok_handler
    if handle?(current_symbol)
      call_handler(current_symbol)
    elsif handle?(:ok)
      super
    else
      activate
    end
  end
  #
  # リフレッシュ
  #
  #
  def refresh
    clear_command_list
    make_command_list
    create_contents
    super
  end
end
